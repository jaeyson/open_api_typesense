defmodule OpenApiTypesense.Synonyms do
  @moduledoc """
  Provides API endpoints related to synonyms
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a synonym associated with a collection
  """
  @spec delete_search_synonym(
          collection_name :: String.t(),
          synonym_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchSynonymDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_synonym(collection_name, synonym_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, synonym_id: synonym_id],
      call: {OpenApiTypesense.Synonyms, :delete_search_synonym},
      url: "/collections/#{collection_name}/synonyms/#{synonym_id}",
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
  @spec get_search_synonym(
          collection_name :: String.t(),
          synonym_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonym(collection_name, synonym_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, synonym_id: synonym_id],
      call: {OpenApiTypesense.Synonyms, :get_search_synonym},
      url: "/collections/#{collection_name}/synonyms/#{synonym_id}",
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
  @spec get_search_synonyms(collection_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.SearchSynonymsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonyms(collection_name, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Synonyms, :get_search_synonyms},
      url: "/collections/#{collection_name}/synonyms",
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

  ## Request Body

  **Content Types**: `application/json`

  The search synonym object to be created/updated
  """
  @spec upsert_search_synonym(
          collection_name :: String.t(),
          synonym_id :: String.t(),
          body :: OpenApiTypesense.SearchSynonymSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_synonym(collection_name, synonym_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, synonym_id: synonym_id, body: body],
      call: {OpenApiTypesense.Synonyms, :upsert_search_synonym},
      url: "/collections/#{collection_name}/synonyms/#{synonym_id}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SearchSynonymSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SearchSynonym, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
