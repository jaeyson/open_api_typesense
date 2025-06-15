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
      req_client = build_req_client(conn, params)
      req_request(req_client, params)
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

  defp req_request(req_client, opts) do
    {_req, resp} = Req.Request.run_request(req_client)
    parse_resp(resp, opts)
  end

  defp parse_resp(%Req.Response{status: code, body: list}, %{response: resp})
       when is_list(list) and code in 200..299 do
    response =
      Enum.find_value(resp, fn {status, [{mod, _t}]} ->
        if status === code do
          Enum.map(list, fn body ->
            struct(mod, body)
          end)
        end
      end)

    {:ok, response}
  end

  defp parse_resp(%Req.Response{status: code, body: body}, %{response: resp})
       when code in 200..299 do
    response =
      Enum.find_value(resp, fn resp ->
        case {resp, body} do
          {{status, {mod, t}}, _} when status === code and t !== :generic ->
            struct(mod, body)

          {{status, [{_mod, t}]}, nil} when status === code and t !== :generic ->
            []

          {{status, :map}, _} when status === code ->
            body

          {_, _} ->
            body
            |> String.splitter("\n")
            |> Enum.map(&Jason.decode!/1)
        end
      end)

    {:ok, response}
  end

  defp parse_resp(%Req.Response{status: code, body: body}, %{response: resp}) do
    message =
      Enum.find_value(resp, fn {status, type} ->
        if status === code do
          {mod, _t} = type
          struct(mod, body)
        end
      end)

    {:error, message}
  end

  defp parse_resp(error, _opts_resp) do
    {:error, Exception.message(error)}
  end

  defp encode_body(opts) do
    if opts[:request] do
      [content_type] = opts[:request]
      parse_content_type(content_type, opts[:args][:body])
    else
      Jason.encode_to_iodata!(opts[:args][:body])
    end
  end

  defp parse_content_type({"application/octet-stream", {:string, :generic}}, body) do
    Enum.map_join(body, "\n", &Jason.encode_to_iodata!/1)
  end

  # defp parse_content_type({"application/json", {module, :t}}, body) when is_atom(module) do
  #   atom_keys = Map.keys(mod.__struct__()) |> Enum.reject(&(&1 == :__struct__))
  #   string_keys = Enum.map(atom_keys, &to_string/1)
  #   keys = atom_keys ++ string_keys

  #   body
  #   |> Map.take(keys)
  #   |> OpenApiTypesense.Converter.to_atom_keys(safe: false)
  #   |> Jason.encode_to_iodata!()
  # end

  defp parse_content_type({"application/json", _}, body) do
    Jason.encode_to_iodata!(body)
  end
end
