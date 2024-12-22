defmodule OpenApiTypesense.Debug do
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
  @spec debug :: {:ok, map()} | :error
  def debug, do: debug(Connection.new())

  @doc """
  Either one of:
  - `debug(opts)`
  - `debug(%{api_key: xyz, host: ...})`
  - `debug(Connection.new())`
  """
  @spec debug(map() | Connection.t() | keyword()) :: {:ok, map()} | :error
  def debug(opts) when is_list(opts) do
    debug(Connection.new(), opts)
  end

  def debug(conn) when not is_struct(conn) and is_map(conn) do
    debug(Connection.new(conn), [])
  end

  def debug(%Connection{} = conn) when is_struct(conn) do
    debug(conn, [])
  end

  @doc """
  Either one of:
  - `debug(%{api_key: xyz, host: ...}, opts)`
  - `debug(Connection.new(), opts)`
  """
  @spec debug(map() | Connection.t(), keyword()) :: {:ok, map()} | :error
  def debug(conn, opts) when not is_struct(conn) and is_map(conn) do
    debug(Connection.new(conn), opts)
  end

  @spec debug(Connection.t(), keyword()) :: {:ok, map()} | :error
  def debug(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Debug, :debug},
      url: "/debug",
      method: :get,
      response: [{200, {OpenApiTypesense.Debug, :debug_200_json_resp}}],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(:debug_200_json_resp) do
    [version: {:string, :generic}]
  end
end
