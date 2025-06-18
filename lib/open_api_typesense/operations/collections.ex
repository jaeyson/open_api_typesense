defmodule OpenApiTypesense.Collections do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to collections
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Create a new collection

  When a collection is created, we give it a name and describe the fields that will be indexed from the documents added to the collection.

  ## Options

    * `src_name`: Clone an existing collection's schema (documents are not copied), overrides and synonyms. The actual documents in the collection are not copied, so this is primarily useful for creating new collections from an existing reference template.

  ## Example
      iex> schema = %{
      ...>   "name" => "houses",
      ...>   "fields" => [
      ...>     %{"name" => "house_type", "type" => "string"},
      ...>     %{"name" => "houses_id", "type" => "int32"},
      ...>     %{"name" => "description", "type" => "string"},
      ...>   ],
      ...>   "default_sorting_field" => "houses_id",
      ...> }
      iex> OpenApiTypesense.Collections.create_collection(schema)

  """
  @doc since: "0.4.0"
  @spec create_collection(body :: OpenApiTypesense.CollectionSchema.t(), opts :: keyword) ::
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
  @doc since: "0.4.0"
  @spec delete_alias(alias_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_alias(alias_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [alias_name: alias_name],
      call: {OpenApiTypesense.Collections, :delete_alias},
      url: "/aliases/#{alias_name}",
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
  @doc since: "0.4.0"
  @spec delete_collection(collection_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_collection(collection_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Collections, :delete_collection},
      url: "/collections/#{collection_name}",
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
  @doc since: "0.4.0"
  @spec get_alias(alias_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_alias(alias_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [alias_name: alias_name],
      call: {OpenApiTypesense.Collections, :get_alias},
      url: "/aliases/#{alias_name}",
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
  @doc since: "0.4.0"
  @spec get_aliases(opts :: keyword) ::
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
  @doc since: "0.4.0"
  @spec get_collection(collection_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collection(collection_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Collections, :get_collection},
      url: "/collections/#{collection_name}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CollectionResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
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
  @doc since: "0.4.0"
  @spec get_collections(opts :: keyword) ::
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
  @doc since: "0.4.0"
  @spec update_collection(
          collection_name :: String.t(),
          body :: OpenApiTypesense.CollectionUpdateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CollectionUpdateSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_collection(collection_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, body: body],
      call: {OpenApiTypesense.Collections, :update_collection},
      url: "/collections/#{collection_name}",
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
  @doc since: "0.4.0"
  @spec upsert_alias(
          alias_name :: String.t(),
          body :: OpenApiTypesense.CollectionAliasSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_alias(alias_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [alias_name: alias_name, body: body],
      call: {OpenApiTypesense.Collections, :upsert_alias},
      url: "/aliases/#{alias_name}",
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
