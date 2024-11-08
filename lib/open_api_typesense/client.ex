defmodule OpenApiTypesense.Client do
  @moduledoc since: "0.1.0"
  @moduledoc """
  Http client for Typesense server.
  """

  alias OpenApiTypesense.Connection

  @typedoc since: "0.1.0"
  @type request_body() :: iodata() | nil

  @typedoc since: "0.1.0"
  @type request_method() :: :get | :post | :delete | :patch | :put

  @typedoc since: "0.1.0"
  @type request_path() :: String.t()

  @doc since: "0.1.0"
  @spec get_host :: String.t() | nil
  def get_host, do: Application.get_env(:ex_typesense, :host)

  @doc since: "0.1.0"
  @spec get_scheme :: String.t() | nil
  def get_scheme, do: Application.get_env(:ex_typesense, :scheme)

  @doc since: "0.1.0"
  @spec get_port :: non_neg_integer() | nil
  def get_port do
    Application.get_env(:ex_typesense, :port)
  end

  @doc """
  Returns the Typesense's API key

  > #### Warning {: .warning}
  >
  > Even if `api_key` is hidden in `Connection` struct, this
  > function will still return the key and accessible inside
  > shell (assuming bad actors [pun unintended `:/`] can get in as well).
  """
  @doc since: "0.1.0"
  @spec api_key :: String.t() | nil
  def api_key, do: Application.get_env(:ex_typesense, :api_key)

  def run(opts \\ %{}) do
    conn = Connection.new()
    # Req.Request.append_error_steps and its retry option are used here.
    # options like retry, max_retries, etc. can be found in:
    # https://hexdocs.pm/req/Req.Steps.html#retry/1
    # NOTE: look at source code in Github
    retry = fn request ->
      if Mix.env() === :test do
        {req, resp_or_err} = request

        # disabled in order to cut time in tests
        req = %{req | options: %{retry: false}}

        Req.Steps.retry({req, resp_or_err})
      else
        Req.Steps.retry(request)
      end
    end

    url =
      %URI{
        scheme: conn.scheme,
        host: conn.host,
        port: conn.port,
        path: opts[:path],
        query: URI.encode_query(opts[:query] || %{})
      }

    response =
      %Req.Request{
        body: opts[:body] || nil,
        method: opts[:method] || :get,
        url: url
      }
      |> Req.Request.put_header("x-typesense-api-key", HttpClient.api_key())
      |> Req.Request.put_header("content-type", opts[:content_type] || "application/json")
      |> Req.Request.append_error_steps(retry: retry)
      |> Req.Request.run!()

    case response.status in 200..299 do
      true ->
        body =
          if opts[:content_type] === "text/plain",
            do: String.split(response.body, "\n", trim: true) |> Enum.map(&Jason.decode!/1),
            else: Jason.decode!(response.body)

        {:ok, body}

      false ->
        {:error, Jason.decode!(response.body)["message"]}
    end

    # @spec request(map) :: {:ok, term} | {:error, term} | Operation.t()
    # def request(%{opts: opts} = info) do
    #   %Operation{
    #     request_method: method,
    #     request_server: server,
    #     request_url: url
    #   } = operation = Operation.new(info)

    #   metadata = %{
    #     client: __MODULE__,
    #     info: info,
    #     request_method: method,
    #     request_server: server,
    #     request_url: url
    #   }

    #   :telemetry.span([:oapi_github, :request], metadata, fn ->
    #     result = reduce_stack(operation)

    #     if Config.wrap(opts) do
    #       wrap_result(result, metadata)
    #     else
    #       {result, Map.put(metadata, :response_code, 0)}
    #     end
    #   end)
    # end
  end
end
