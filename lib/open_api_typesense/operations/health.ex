defmodule OpenApiTypesense.Health do
  @moduledoc """
  Provides API endpoint related to health
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Checks if Typesense server is ready to accept requests.

  Checks if Typesense server is ready to accept requests.
  """

  @spec health :: {:ok, OpenApiTypesense.HealthStatus.t()} | :error
  def health, do: health(Connection.new(), [])

  @doc """
  Either one of:
  - `health(opts)`
  - `health(%{api_key: xyz, host: ...})`
  - `health(Connection.new())`
  """
  @spec health(Connection.t() | map() | keyword()) ::
          {:ok, OpenApiTypesense.HealthStatus.t()} | :error
  def health(%Connection{} = conn) when is_struct(conn) do
    health(conn, [])
  end

  def health(conn) when not is_struct(conn) and is_map(conn) do
    health(Connection.new(conn), [])
  end

  def health(opts) when is_list(opts) do
    health(Connection.new(), opts)
  end

  @doc """
  Either one of:
  - `health(%{api_key: xyz, host: ...}, opts)`
  - `health(Connection.new(), opts)`
  """
  @spec health(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.HealthStatus.t()} | :error
  def health(conn, opts) when not is_struct(conn) and is_map(conn) do
    health(Connection.new(conn), opts)
  end

  def health(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Health, :health},
      url: "/health",
      method: :get,
      response: [{200, {OpenApiTypesense.HealthStatus, :t}}],
      opts: opts
    })
  end
end
