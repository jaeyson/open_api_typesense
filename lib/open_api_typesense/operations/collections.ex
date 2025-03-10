defmodule OpenApiTypesense.Collections do
  @moduledoc """
  Provides API endpoints related to collections
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Create a new collection

  When a collection is created, we give it a name and describe the fields that will be indexed from the documents added to the collection.

  ## Options

    * `src_name`: Clone an existing collection's schema (documents are not copied), overrides and synonyms. The actual documents in the collection are not copied, so this is primarily useful for creating new collections from an existing reference template.

  """
  @spec create_collection(OpenApiTypesense.CollectionSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_collection(body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:src_name])

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Collections, :create_collection},
      url: "/collections",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", {OpenApiTypesense.CollectionSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.CollectionResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an alias
  """
  @spec delete_alias(String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_alias(aliasName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [aliasName: aliasName],
      call: {OpenApiTypesense.Collections, :delete_alias},
      url: "/aliases/#{aliasName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a collection

  Permanently drops a collection. This action cannot be undone. For large collections, this might have an impact on read latencies.
  """
  @spec delete_collection(String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_collection(collectionName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Collections, :delete_collection},
      url: "/collections/#{collectionName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CollectionResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve an alias

  Find out which collection an alias points to by fetching it
  """
  @spec get_alias(String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_alias(aliasName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [aliasName: aliasName],
      call: {OpenApiTypesense.Collections, :get_alias},
      url: "/aliases/#{aliasName}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all aliases

  List all aliases and the corresponding collections that they map to.
  """
  @spec get_aliases(keyword) ::
          {:ok, OpenApiTypesense.CollectionAliasesResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_aliases(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Collections, :get_aliases},
      url: "/aliases",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CollectionAliasesResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a single collection

  Retrieve the details of a collection, given its name.
  """
  @spec get_collection(String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collection(collectionName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Collections, :get_collection},
      url: "/collections/#{collectionName}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CollectionResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all collections

  Returns a summary of all your collections. The collections are returned sorted by creation date, with the most recent collections appearing first.

  ## Options

    * `limit`: Limit results in paginating on collection listing.
    * `offset`: Skip a certain number of results and start after that.
    * `exclude_fields`: Exclude the field definitions from being returned in the response.

  """
  @spec get_collections(keyword) ::
          {:ok, [OpenApiTypesense.CollectionResponse.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collections(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:exclude_fields, :limit, :offset])

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Collections, :get_collections},
      url: "/collections",
      method: :get,
      query: query,
      response: [
        {200, [{OpenApiTypesense.CollectionResponse, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update a collection

  Update a collection's schema to modify the fields and their types.
  """
  @spec update_collection(String.t(), OpenApiTypesense.CollectionUpdateSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionUpdateSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_collection(collectionName, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collectionName: collectionName, body: body],
      call: {OpenApiTypesense.Collections, :update_collection},
      url: "/collections/#{collectionName}",
      body: body,
      method: :patch,
      request: [{"application/json", {OpenApiTypesense.CollectionUpdateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CollectionUpdateSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a collection alias

  Create or update a collection alias. An alias is a virtual collection name that points to a real collection. If you're familiar with symbolic links on Linux, it's very similar to that. Aliases are useful when you want to reindex your data in the background on a new collection and switch your application to it without any changes to your code.
  """
  @spec upsert_alias(String.t(), OpenApiTypesense.CollectionAliasSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_alias(aliasName, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [aliasName: aliasName, body: body],
      call: {OpenApiTypesense.Collections, :upsert_alias},
      url: "/aliases/#{aliasName}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.CollectionAliasSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
