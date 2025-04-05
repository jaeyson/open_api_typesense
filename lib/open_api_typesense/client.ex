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
  @callback request(conn :: map(), params :: keyword()) :: response()

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
  @spec request(map() | Connection.t(), map()) :: response()
  def request(conn, opts) do
    client = Map.get(conn, :client)

    if client do
      client.request(conn, opts)
    else
      req_client = build_req_client(conn, opts)
      req_request(req_client, opts)
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
    parse_resp(resp, opts[:response])
  end

  defp encode_body(opts) do
    if opts[:request] do
      [content_type] = opts[:request]
      parse_content_type(content_type, opts[:body])
    else
      Jason.encode_to_iodata!(opts[:body])
    end
  end

  defp parse_content_type({"application/octet-stream", {:string, :generic}}, body) do
    Enum.map_join(body, "\n", &Jason.encode_to_iodata!/1)
  end

  defp parse_content_type({"application/json", _}, body) do
    Jason.encode_to_iodata!(body)
  end

  # defp parse_content_type({"application/json", {mod, :t}}, body) do
  #   # Checks if map keys are atom or string
  #   if Enum.all?(Map.keys(body), &is_atom/1) do
  #       Jason.encode_to_iodata!(struct(mod, body))
  #   else
  #     Jason.encode_to_iodata!(body)
  #   end
  # end

  # Some resources are missing 4xx descriptions, hence we will set a default
  # instead so we can see the actual error message instead of stacktrace.
  # See https://github.com/typesense/typesense-api-spec/pull/84
  defp parse_resp(%Req.Response{} = resp, status_type) do
    {status, type} =
      status_type
      |> Enum.find(fn {status, _type} -> status == resp.status end) ||
        {resp.status, :map}

    parse_values(status, type, resp.body)
  end

  defp parse_resp(error, _opts_resp) do
    {:error, Exception.message(error)}
  end

  @spec parse_values(
          non_neg_integer(),
          atom() | list() | tuple(),
          map() | String.t() | list()
        ) ::
          {:ok, any()} | {:error, any()}
  defp parse_values(code, :map, body) do
    status = if code in 200..299, do: :ok, else: :error

    {status, body}
  end

  defp parse_values(code, values, body) when is_list(values) do
    status = if code in 200..299, do: :ok, else: :error

    resp =
      values
      |> Enum.map(fn {module, _func_name} ->
        cond do
          is_list(body) ->
            Enum.map(body, fn single_body ->
              struct(module, single_body)
            end)

          is_nil(body) ->
            []

          true ->
            struct(module, body)
        end
      end)
      |> List.flatten()

    {status, resp}
  end

  defp parse_values(code, {module, _func_name} = _values, body) when module == :string do
    status = if code in 200..299, do: :ok, else: :error

    case status do
      :ok ->
        resp =
          body
          |> String.splitter("\n")
          |> Enum.map(&Jason.decode!/1)

        {status, resp}

      :error ->
        {status, struct(ApiResponse, message: Jason.decode!(body)["error"])}
    end
  end

  defp parse_values(code, {module, _func_name} = _values, body) do
    status = if code in 200..299, do: :ok, else: :error

    {status, struct(module, body)}
  end
end
