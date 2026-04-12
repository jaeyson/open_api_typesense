defmodule OpenApiTypesense.Synonyms do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to synonyms
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a synonym set

  Delete a specific synonym set by its name
  """
  @doc since: "1.2.0"
  @spec delete_synonym_set(synonym_set_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.SynonymSetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_synonym_set(synonym_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name],
      call: {OpenApiTypesense.Synonyms, :delete_synonym_set},
      url: "/synonym_sets/#{synonym_set_name}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.SynonymSetDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a synonym set item

  Delete a specific synonym item by its id
  """
  @doc since: "1.2.0"
  @spec delete_synonym_set_item(
          synonym_set_name :: String.t(),
          item_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SynonymItemDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_synonym_set_item(synonym_set_name, item_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name, item_id: item_id],
      call: {OpenApiTypesense.Synonyms, :delete_synonym_set_item},
      url: "/synonym_sets/#{synonym_set_name}/items/#{item_id}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.SynonymItemDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a synonym associated with a collection
  """
  @doc since: "0.4.0"
  @deprecated "Please use delete_synonym_set/2 or delete_synonym_set_item/3 when using Typesense v30.0+"
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
  List all synonym sets

  Retrieve all synonym sets
  """
  @doc since: "1.2.0"
  @spec retrieve_synonym_sets(opts :: keyword) ::
          {:ok, [OpenApiTypesense.SynonymSetSchema.t()]} | :error
  def retrieve_synonym_sets(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Synonyms, :retrieve_synonym_sets},
      url: "/synonym_sets",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.SynonymSetSchema, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a synonym set

  Retrieve a specific synonym set by its name
  """
  @doc since: "1.2.0"
  @spec retrieve_synonym_set(synonym_set_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.SynonymSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_synonym_set(synonym_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name],
      call: {OpenApiTypesense.Synonyms, :retrieve_synonym_set},
      url: "/synonym_sets/#{synonym_set_name}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SynonymSetSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a synonym set item

  Retrieve a specific synonym item by its id
  """
  @doc since: "1.2.0"
  @spec retrieve_synonym_set_item(
          synonym_set_name :: String.t(),
          item_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SynonymItemSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_synonym_set_item(synonym_set_name, item_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name, item_id: item_id],
      call: {OpenApiTypesense.Synonyms, :retrieve_synonym_set_item},
      url: "/synonym_sets/#{synonym_set_name}/items/#{item_id}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SynonymItemSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List items in a synonym set

  Retrieve all synonym items in a set
  """
  @doc since: "1.2.0"
  @spec retrieve_synonym_set_items(synonym_set_name :: String.t(), opts :: keyword) ::
          {:ok, [OpenApiTypesense.SynonymItemSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_synonym_set_items(synonym_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name],
      call: {OpenApiTypesense.Synonyms, :retrieve_synonym_set_items},
      url: "/synonym_sets/#{synonym_set_name}/items",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.SynonymItemSchema, :t}]},
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
  @doc since: "0.4.0"
  @deprecated "Please use retrieve_synonym_set/2 or retrieve_synonym_set_item/3 when using Typesense v30.0+"
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
  @doc since: "0.4.0"
  @deprecated "Please use retrieve_synonym_set_items/2 or retrieve_synonym_sets/1 when using Typesense v30.0+"
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
  Create or update a synonym set

  Create or update a synonym set with the given name

  ## Request Body

  **Content Types**: `application/json`

  The synonym set to be created/updated
  """
  @doc since: "1.2.0"
  @spec upsert_synonym_set(
          synonym_set_name :: String.t(),
          body :: OpenApiTypesense.SynonymSetCreateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SynonymSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_synonym_set(synonym_set_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name, body: body],
      call: {OpenApiTypesense.Synonyms, :upsert_synonym_set},
      url: "/synonym_sets/#{synonym_set_name}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SynonymSetCreateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SynonymSetSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a synonym set item

  Create or update a synonym set item with the given id

  ## Request Body

  **Content Types**: `application/json`

  The synonym item to be created/updated
  """
  @doc since: "1.2.0"
  @spec upsert_synonym_set_item(
          synonym_set_name :: String.t(),
          item_id :: String.t(),
          body :: OpenApiTypesense.SynonymItemUpsertSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SynonymItemSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_synonym_set_item(synonym_set_name, item_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [synonym_set_name: synonym_set_name, item_id: item_id, body: body],
      call: {OpenApiTypesense.Synonyms, :upsert_synonym_set_item},
      url: "/synonym_sets/#{synonym_set_name}/items/#{item_id}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SynonymItemUpsertSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SynonymItemSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
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
  @doc since: "0.4.0"
  @deprecated "Please use upsert_synonym_set/3 or upsert_synonym_set_item/4 when using Typesense v30.0+"
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
