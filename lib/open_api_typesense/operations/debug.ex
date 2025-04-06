defmodule OpenApiTypesense.Debug do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoint related to debug
  """

  defstruct [:version]

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @type debug_200_json_resp :: %{version: String.t() | nil}

  @doc """
  Print debugging information

  Print debugging information
  """
  @doc since: "0.4.0"
  @spec debug :: {:ok, map()} | {:ok, map()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def debug, do: debug([])

  @doc """
  Either one of:
  - `debug(opts)`
  - `debug(%{api_key: xyz, host: ...})`
  - `debug(Connection.new())`
  """
  @doc since: "0.4.0"
  @spec debug(map() | Connection.t() | keyword()) ::
          {:ok, map()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def debug(opts) when is_list(opts) do
    debug(Connection.new(), opts)
  end

  def debug(conn) do
    debug(conn, [])
  end

  @doc """
  Either one of:
  - `debug(%{api_key: xyz, host: ...}, opts)`
  - `debug(Connection.new(), opts)`
  """
  @doc since: "0.4.0"
  @spec debug(map() | Connection.t(), keyword()) ::
          {:ok, map()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def debug(conn, opts) when not is_struct(conn) and is_map(conn) do
    debug(Connection.new(conn), opts)
  end

  def debug(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Debug, :debug},
      url: "/debug",
      method: :get,
      response: [
        {200, {OpenApiTypesense.Debug, :debug_200_json_resp}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(:debug_200_json_resp) do
    [version: {:string, :generic}]
  end
end
