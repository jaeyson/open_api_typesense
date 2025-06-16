defmodule OpenApiTypesense.Client do
  @moduledoc since: "0.2.0"
  @moduledoc """
  Http client for Typesense server.
  """

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.ApiResponse

  @doc """
  A callback function for custom HTTP client
  """
  @doc since: "0.2.0"
  @callback request(params :: map()) :: response()

  @typedoc since: "0.2.0"
  @type response() ::
          {:ok, any()}
          | {:error, ApiResponse.t()}
          | {:error, String.t()}
          | {:error, list()}
          | :error

  @doc """
  Returns the Typesense's API key

  > #### Warning {: .warning}
  >
  > Even if `api_key` is hidden in `Connection` struct, this
  > function will still return the key and accessible inside
  > shell (assuming bad actors [pun unintended `:/`] can get in as well).
  """
  @doc since: "0.2.0"
  @spec api_key :: String.t() | nil
  def api_key, do: Application.get_env(:open_api_typesense, :api_key)

  @doc """
  Command for making http requests.

  > #### On using this function {: .info}
  > Functions e.g. `OpenApiTypesense.Health.health` don't need to explicitly pass
  > a `connection` unless you want to use custom `connection`. See
  > [`README`](/README.md) for more details or `OpenApiTypesense.Connection` module.

  ## Options

  - `:body`: Payload for passing as request body (defaults to `nil`).
  - `:url`: Request path.
  - `:method`: Request method (e.g. `:get`, `:post`, `:put`, `:patch`, `:delete`). Defaults to `:get`.
  - `:query`: Request query params (defaults to `%{}`).

  ## Examples
      iex> connection = %OpenApiTypesense.Connection{
      ...>   host: "localhost",
      ...>   api_key: "some_api_key",
      ...>   port: "8108",
      ...>   scheme: "http"
      ...> }
      iex> opts = %{
      ...>   url: "/health",
      ...>   method: :get
      ...> }
      iex> Client.request(connection, opts)
      {:ok, %OpenApiTypesense.HealthStatus{ok: true}}
  """
  @doc since: "0.2.0"
  @spec request(map()) :: response()
  def request(params) do
    conn =
      if params.opts[:conn] do
        Connection.new(params.opts[:conn])
      else
        Connection.new()
      end

    client = Map.get(conn, :client)

    if client do
      client.request(conn, params)
    else
      {_req, resp} =
        conn
        |> build_req_client(params)
        |> Req.Request.run_request()

      parse_resp(resp, params)
    end
  end

  def build_req_client(conn, opts) do
    # Default request options. These can be overridden in this hierarchy:
    # 1. Via the `:options` key in `config.exs`.
    # 2. By passing `:req` key to `opts` arg to request/2.
    req_options =
      conn
      |> Map.get(:options, [])
      |> Keyword.merge(Access.get(opts, :req, []))

    url =
      %URI{
        scheme: conn.scheme,
        host: conn.host,
        port: conn.port,
        path: Access.get(opts, :url),
        query: URI.encode_query(Access.get(opts, :query, []))
      }

    [
      method: Access.get(opts, :method, :get),
      body: encode_body(opts),
      url: url,
      decode_json: [keys: :atoms]
    ]
    |> Req.new()
    |> Req.Request.merge_options(req_options)
    |> Req.Request.put_header("x-typesense-api-key", Map.get(conn, :api_key))
  end

  defp encode_body(opts) do
    body = opts[:args][:body]

    case {opts[:request], body} do
      {nil, _} ->
        Jason.encode_to_iodata!(body)

      {[{"application/octet-stream", {:string, :generic}}], body} when not is_binary(body) ->
        Enum.map_join(body, "\n", &Jason.encode_to_iodata!/1)

      {[{"application/json", _}], body} when not is_binary(body) ->
        Jason.encode_to_iodata!(body)

      {_, body} when is_binary(body) ->
        body
    end
  end

  defp parse_resp(%Req.Response{status: code, body: body}, %{response: resp}) do
    {_status, mod} = Enum.find(resp, fn {status, _} -> status === code end)
    parse_body(code, mod, body)
  end

  defp parse_resp(error, _opts_resp) do
    {:error, Exception.message(error)}
  end

  defp parse_body(code, _, %{message: reason}) when code in 400..499 do
    {:error, struct(OpenApiTypesense.ApiResponse, message: reason)}
  end

  defp parse_body(_code, [{mod, _t}], list) when is_list(list) do
    {:ok, Enum.map(list, &struct(mod, &1))}
  end

  defp parse_body(_code, {:string, :generic}, "") do
    {:ok, ""}
  end

  defp parse_body(_code, {:string, :generic}, body) do
    body =
      body
      |> String.splitter("\n")
      |> Enum.map(&Jason.decode!/1)

    {:ok, body}
  end

  defp parse_body(_code, :map, body) do
    {:ok, body}
  end

  defp parse_body(_code, _, nil) do
    {:ok, []}
  end

  defp parse_body(_code, {mod, _t}, body) do
    {:ok, struct(mod, body)}
  end
end
