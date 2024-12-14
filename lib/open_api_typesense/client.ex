defmodule OpenApiTypesense.Client do
  @moduledoc since: "0.2.0"
  @moduledoc """
  Http client for Typesense server.
  """

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.ApiResponse

  @typedoc since: "0.2.0"
  @type response() ::
          {:ok, any()}
          | {:error, ApiResponse.t()}
          | {:error, String.t()}
          | :error

  @doc since: "0.2.0"
  @spec get_host :: String.t() | nil
  def get_host, do: Application.get_env(:open_api_typesense, :host)

  @doc since: "0.2.0"
  @spec get_scheme :: String.t() | nil
  def get_scheme, do: Application.get_env(:open_api_typesense, :scheme)

  @doc since: "0.2.0"
  @spec get_port :: non_neg_integer() | nil
  def get_port do
    Application.get_env(:open_api_typesense, :port)
  end

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
  > a `connection` unless you want to use custom `connection`. See [`README`](/README.md) for
  > more details or `OpenApiTypesense.Connection` module.

  ## Options

  - `:body`: Payload for passing as request body (defaults to `nil`).
  - `:url`: Request path.
  - `:method`: Request method (e.g. `:get`, `:post`, `:put`, `:patch`, `:delete`). Defaults to `:get`.
  - `:query`: Request query params (defaults to `%{}`).

  ## Examples
      iex> alias OpenApiTypesense.Client

      iex> connection = %OpenApiTypesense.Connection{
      ...>   host: "localhost",
      ...>   api_key: "some_api_key",
      ...>   port: "8108",
      ...>   scheme: "http"
      ...> }

      iex> opts = %{
      ...>   args: [],
      ...>   call: {OpenApiTypesense.Health, :health},
      ...>   url: "/health",
      ...>   method: :get,
      ...>   response: [{200, {OpenApiTypesense.HealthStatus, :t}}],
      ...>   opts: opts
      ...> }

      iex> Client.request(connection, opts)
      {:ok, %OpenApiTypesense.HealthStatus{ok: true}}
  """
  @doc since: "0.2.0"
  @spec request(Connection.t(), list()) :: response()
  def request(conn, opts \\ []) do
    # Req.Request.append_error_steps and its retry option are used here.
    # options like retry, max_retries, etc. can be found in:
    # https://hexdocs.pm/req/Req.Steps.html#retry/1
    # NOTE: look at source code in Github
    retry =
      if Mix.env() === :test do
        # disabled in order to cut time in tests
        false
      else
        :safe_transient
      end

    max_retries =
      if Mix.env() === :test do
        # disabled in order to cut time in tests
        0
      else
        # default
        3
      end

    url =
      %URI{
        scheme: conn.scheme,
        host: conn.host,
        port: conn.port,
        path: opts[:url],
        query: URI.encode_query(opts[:opts] || [])
      }

    {_req, resp} =
      [
        method: opts[:method] || :get,
        body: opts[:body],
        url: url,
        retry: retry,
        max_retries: max_retries,
        compress_body: opts[:opts][:compress] || false,
        cache: opts[:opts][:cache] || false,
        decode_json: [keys: :atoms]
      ]
      |> Req.new()
      |> Req.Request.put_header("x-typesense-api-key", api_key())
      |> Req.Request.run_request()

    parse_resp(resp, opts[:response])
  end

  defp parse_resp(%Req.TransportError{} = error, _opts_resp) do
    {:error, Exception.message(error)}
  end

  defp parse_resp(%Req.HTTPError{} = error, _opts_resp) do
    {:error, Exception.message(error)}
  end

  defp parse_resp(resp, opts_resp) do
    {code, values} =
      opts_resp
      |> Enum.find(fn {code, _values} ->
        code === resp.status
      end)

    parse_values(code, values, resp.body)
  end

  defp parse_values(code, :map, body) do
    status = if code in 200..299, do: :ok, else: :error

    {status, body}
  end

  defp parse_values(code, values, body) when is_list(values) do
    status = if code in 200..299, do: :ok, else: :error

    resp =
      values
      |> Enum.map(fn {module, _func_name} ->
        if is_list(body) do
          Enum.map(body, fn single_body ->
            struct(module, single_body)
          end)
        else
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
