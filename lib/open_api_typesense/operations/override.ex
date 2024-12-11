defmodule OpenApiTypesense.Override do
  @moduledoc """
  Provides API endpoint related to override
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Retrieve a single search override

  Retrieve the details of a search override, given its id.
  """
  @spec get_search_override(Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | :error
  def get_search_override(conn \\ Connection.new(), collectionName, overrideId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId],
      call: {OpenApiTypesense.Override, :get_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
