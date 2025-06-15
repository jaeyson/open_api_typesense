defmodule OpenApiTypesense.Health do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoint related to health
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Checks if Typesense server is ready to accept requests.

  Checks if Typesense server is ready to accept requests.
  """
  @doc since: "0.4.0"
  @spec health(opts :: keyword) :: {:ok, OpenApiTypesense.HealthStatus.t()} | :error
  def health(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Health, :health},
      url: "/health",
      method: :get,
      response: [{200, {OpenApiTypesense.HealthStatus, :t}}],
      opts: opts
    })
  end
end
