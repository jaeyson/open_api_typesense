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
  @spec health(Connection.t(), keyword) :: {:ok, OpenApiTypesense.HealthStatus.t()} | :error
  def health(conn \\ Connection.new(), opts \\ []) do
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
