defmodule OpenApiTypesense.Curation do
  @moduledoc """
  Provides API endpoints related to curation
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete an override associated with a collection
  """
  @spec delete_search_override(String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collectionName, overrideId, opts \\ []) do
    delete_search_override(Connection.new(), collectionName, overrideId, opts)
  end

  @spec delete_search_override(Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(conn, collectionName, overrideId, opts) do
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
  @spec get_search_overrides(String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(collectionName, opts \\ []) do
    get_search_overrides(Connection.new(), collectionName, opts)
  end

  @spec get_search_overrides(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(conn, collectionName, opts) do
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
          String.t(),
          String.t(),
          OpenApiTypesense.SearchOverrideSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(
        collectionName,
        overrideId,
        body,
        opts \\ []
      ) do
    upsert_search_override(Connection.new(), collectionName, overrideId, body, opts)
  end

  @spec upsert_search_override(
          Connection.t(),
          String.t(),
          String.t(),
          OpenApiTypesense.SearchOverrideSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(
        conn,
        collectionName,
        overrideId,
        body,
        opts
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
