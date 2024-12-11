defmodule OpenApiTypesense.Curation do
  @moduledoc """
  Provides API endpoints related to curation
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete an override associated with a collection
  """
  @spec delete_search_override(Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(conn \\ Connection.new(), collectionName, overrideId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId],
      call: {OpenApiTypesense.Curation, :delete_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.SearchOverrideDeleteResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all collection overrides
  """
  @spec get_search_overrides(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(conn \\ Connection.new(), collectionName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Curation, :get_search_overrides},
      url: "/collections/#{collectionName}/overrides",
      method: :get,
      response: [{200, {OpenApiTypesense.SearchOverridesResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Create or update an override to promote certain documents over others

  Create or update an override to promote certain documents over others. Using overrides, you can include or exclude specific documents for a given query.
  """
  @spec upsert_search_override(
          Connection.t(),
          String.t(),
          String.t(),
          OpenApiTypesense.SearchOverrideSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(
        conn \\ Connection.new(),
        collectionName,
        overrideId,
        body,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId, body: body],
      call: {OpenApiTypesense.Curation, :upsert_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SearchOverrideSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
