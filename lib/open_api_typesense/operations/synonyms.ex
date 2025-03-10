defmodule OpenApiTypesense.Synonyms do
  @moduledoc """
  Provides API endpoints related to synonyms
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a synonym associated with a collection
  """
  @spec delete_search_synonym(String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchSynonymDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_synonym(collectionName, synonymId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName, synonymId: synonymId],
      call: {OpenApiTypesense.Synonyms, :delete_search_synonym},
      url: "/collections/#{collectionName}/synonyms/#{synonymId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.SearchSynonymDeleteResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a single search synonym

  Retrieve the details of a search synonym, given its id.
  """
  @spec get_search_synonym(String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonym(collectionName, synonymId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName, synonymId: synonymId],
      call: {OpenApiTypesense.Synonyms, :get_search_synonym},
      url: "/collections/#{collectionName}/synonyms/#{synonymId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchSynonym, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all collection synonyms

  ## Options

    * `limit`: Limit results in paginating on collection listing.
    * `offset`: Skip a certain number of results and start after that.

  """
  @spec get_search_synonyms(String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchSynonymsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonyms(collectionName, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Synonyms, :get_search_synonyms},
      url: "/collections/#{collectionName}/synonyms",
      method: :get,
      query: query,
      response: [
        {200, {OpenApiTypesense.SearchSynonymsResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a synonym

  Create or update a synonym  to define search terms that should be considered equivalent.
  """
  @spec upsert_search_synonym(
          String.t(),
          String.t(),
          OpenApiTypesense.SearchSynonymSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_synonym(collectionName, synonymId, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName, synonymId: synonymId, body: body],
      call: {OpenApiTypesense.Synonyms, :upsert_search_synonym},
      url: "/collections/#{collectionName}/synonyms/#{synonymId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SearchSynonymSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SearchSynonym, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
