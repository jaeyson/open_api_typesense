defmodule OpenApiTypesense.Collections do
  @moduledoc """
  Provides API endpoints related to collections
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Create a new collection

  When a collection is created, we give it a name and describe the fields that will be indexed from the documents added to the collection.

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
  @spec create_collection(map()) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_collection(body) do
    create_collection(Connection.new(), body)
  end

  @doc """
  Either one of:
  - `create_collection(schema, opts)`
  - `create_collection(%{api_key: xyz, host: ...}, schema)`
  - `create_collection(Connection.new(), schema)`
  """
  @spec create_collection(map() | Connection.t(), map() | keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_collection(body, opts) when is_list(opts) do
    create_collection(Connection.new(), body, opts)
  end

  def create_collection(conn, body) when not is_struct(conn) and is_map(conn) and is_map(body) do
    create_collection(Connection.new(conn), body, [])
  end

  def create_collection(%Connection{} = conn, body) when is_struct(conn) and is_map(body) do
    create_collection(conn, body, [])
  end

  @doc """
  Either one of:
  - `create_collection(%{api_key: 123, host: ...}, schema, opts)`
  - `create_collection(Connection.new(), schema, opts)`
  """
  @spec create_collection(map() | Connection.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_collection(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    create_collection(Connection.new(conn), body, opts)
  end

  def create_collection(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [body: body],
      call: {OpenApiTypesense.Collections, :create_collection},
      url: "/collections",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.CollectionSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.CollectionResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an alias
  """
  @spec delete_alias(String.t()) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_alias(aliasName) do
    delete_alias(Connection.new(), aliasName)
  end

  @doc """
  Either one of:
  - `delete_alias(aliasName, opts)`
  - `delete_alias(%{api_key: 123, host: ...}, aliasName)`
  - `delete_alias(Connection.new(), aliasName)`
  """
  @spec delete_alias(String.t() | map() | Connection.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_alias(aliasName, opts) when is_binary(aliasName) do
    delete_alias(Connection.new(), aliasName, opts)
  end

  def delete_alias(conn, aliasName) when not is_struct(conn) and is_map(conn) do
    delete_alias(conn, aliasName, [])
  end

  def delete_alias(%Connection{} = conn, aliasName) when is_struct(conn) do
    delete_alias(conn, aliasName, [])
  end

  @doc """
  Either one of:
  - `delete_alias(%{api_key: 123, host: ...}, aliasName, opts)`
  - `delete_alias(Connection.new(), aliasName, opts)`
  """
  @spec delete_alias(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_alias(conn, aliasName, opts) when not is_struct(conn) and is_map(conn) do
    delete_alias(Connection.new(conn), aliasName, opts)
  end

  def delete_alias(%Connection{} = conn, aliasName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [aliasName: aliasName],
      call: {OpenApiTypesense.Collections, :delete_alias},
      url: "/aliases/#{aliasName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a collection

  Permanently drops a collection. This action cannot be undone. For large collections, this might have an impact on read latencies.
  """
  @spec delete_collection(String.t()) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_collection(collectionName) do
    delete_collection(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `delete_collection(collectionName, opts)`
  - `delete_collection(%{api_key: 123, host: ...}, collectionName)`
  - `delete_collection(Connection.new(), collectionName)`
  """
  @spec delete_collection(String.t() | map() | Connection.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_collection(collectionName, opts) when is_binary(collectionName) do
    delete_collection(Connection.new(), collectionName, opts)
  end

  def delete_collection(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    delete_collection(Connection.new(conn), collectionName, [])
  end

  def delete_collection(%Connection{} = conn, collectionName) when is_struct(conn) do
    delete_collection(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `delete_collection(%{api_key: 123, host: ...}, collectionName, opts)`
  - `delete_collection(Connection.new(), collectionName, opts)`
  """
  @spec delete_collection(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_collection(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    delete_collection(Connection.new(conn), collectionName, opts)
  end

  def delete_collection(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Collections, :delete_collection},
      url: "/collections/#{collectionName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CollectionResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve an alias

  Find out which collection an alias points to by fetching it
  """
  @spec get_alias(String.t()) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_alias(aliasName) do
    get_alias(Connection.new(), aliasName)
  end

  @doc """
  Either one of:
  - `get_alias(aliasName, opts)`
  - `get_alias(%{api_key: 123, host: ...}, aliasName)`
  - `get_alias(Connection.new(), aliasName)`
  """
  @spec get_alias(String.t() | map() | Connection.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_alias(aliasName, opts) when is_binary(aliasName) do
    get_alias(Connection.new(), aliasName, opts)
  end

  def get_alias(conn, aliasName) when not is_struct(conn) and is_map(conn) do
    get_alias(Connection.new(conn), aliasName, [])
  end

  def get_alias(%Connection{} = conn, aliasName) when is_struct(conn) do
    get_alias(Connection.new(), aliasName, [])
  end

  @doc """
  Either one of:
  - `get_alias(%{api_key: 123, host: ...}, aliasName, opts)`
  - `get_alias(Connection.new(), aliasName, opts)`
  """
  @spec get_alias(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_alias(conn, aliasName, opts) when not is_struct(conn) and is_map(conn) do
    get_alias(Connection.new(conn), aliasName, opts)
  end

  def get_alias(%Connection{} = conn, aliasName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [aliasName: aliasName],
      call: {OpenApiTypesense.Collections, :get_alias},
      url: "/aliases/#{aliasName}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all aliases

  List all aliases and the corresponding collections that they map to.
  """
  @spec get_aliases :: {:ok, OpenApiTypesense.CollectionAliasesResponse.t()} | :error
  def get_aliases do
    get_aliases(Connection.new())
  end

  @doc """
  Either one of:
  - `get_aliases(opts)`
  - `get_aliases(%{api_key: 123, host: ...})`
  - `get_aliases(Connection.new())`
  """
  @spec get_aliases(map() | Connection.t() | keyword) ::
          {:ok, OpenApiTypesense.CollectionAliasesResponse.t()} | :error
  def get_aliases(opts) when is_list(opts) do
    get_aliases(Connection.new(), opts)
  end

  def get_aliases(conn) when not is_struct(conn) and is_map(conn) do
    get_aliases(Connection.new(conn), [])
  end

  def get_aliases(%Connection{} = conn) when is_struct(conn) do
    get_aliases(conn, [])
  end

  @doc """
  Either one of:
  - `get_aliases(%{api_key: 123, host: ...}, opts)`
  - `get_aliases(Connection.new(), opts)`
  """
  @spec get_aliases(map() | Connection.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAliasesResponse.t()} | :error
  def get_aliases(conn, opts) when not is_struct(conn) and is_map(conn) do
    get_aliases(Connection.new(conn), opts)
  end

  def get_aliases(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Collections, :get_aliases},
      url: "/aliases",
      method: :get,
      response: [{200, {OpenApiTypesense.CollectionAliasesResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Retrieve a single collection

  Retrieve the details of a collection, given its name.
  """
  @spec get_collection(String.t()) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collection(collectionName) do
    get_collection(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `get_collection(collectionName, opts)`
  - `get_collection(%{api_key: 123, host: ...}, collectionName)`
  - `get_collection(Connection.new(), collectionName)`
  """
  @spec get_collection(map() | Connection.t() | String.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collection(collectionName, opts) when is_binary(collectionName) do
    get_collection(Connection.new(), collectionName, opts)
  end

  def get_collection(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    get_collection(Connection.new(conn), collectionName, [])
  end

  def get_collection(%Connection{} = conn, collectionName) when is_struct(conn) do
    get_collection(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `get_collection(%{api_key: 123, host: ...}, collectionName, opts)`
  - `get_collection(Connection.new(), collectionName, opts)`
  """
  @spec get_collection(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.CollectionResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_collection(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    get_collection(Connection.new(conn), collectionName, opts)
  end

  def get_collection(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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

  - `get_collections()`
  - `get_collections(Connection.new())`
  - `get_collections(%{api_key: xyz, host: ...})`
  - `get_collections(exclude_fields: "fields")`
  - `get_collections(conn, limit: 10)` where conn is `%Connection{}` or `%{...}`
  """
  @spec get_collections :: {:ok, [OpenApiTypesense.CollectionResponse.t()]} | :error
  def get_collections, do: get_collections(Connection.new())

  @spec get_collections(map() | Connection.t() | keyword) ::
          {:ok, [OpenApiTypesense.CollectionResponse.t()]} | :error
  def get_collections(opts) when is_list(opts) do
    get_collections(Connection.new(), opts)
  end

  def get_collections(conn) when not is_struct(conn) and is_map(conn) do
    get_collections(Connection.new(conn), [])
  end

  def get_collections(%Connection{} = conn) when is_struct(conn) do
    get_collections(conn, [])
  end

  @doc """
  Either one of:
  - `get_collections(%{api_key: 123, host: ...}, opts)`
  - `get_collections(Connection.new(), opts)`
  """
  @spec get_collections(map() | Connection.t(), keyword) ::
          {:ok, [OpenApiTypesense.CollectionResponse.t()]} | :error
  def get_collections(conn, opts) when not is_struct(conn) do
    get_collections(Connection.new(conn), opts)
  end

  def get_collections(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Collections, :get_collections},
      url: "/collections",
      method: :get,
      response: [{200, [{OpenApiTypesense.CollectionResponse, :t}]}],
      opts: opts
    })
  end

  @doc """
  Update a collection

  Update a collection's schema to modify the fields and their types.
  """
  @spec update_collection(String.t(), map()) ::
          {:ok, OpenApiTypesense.CollectionUpdateSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_collection(collectionName, body) do
    update_collection(Connection.new(), collectionName, body)
  end

  @doc """
  Either one of:
  - `update_collection(collectionName, body, opts)`
  - `update_collection(%{api_key: 123, host: ...}, collectionName, body)`
  - `update_collection(Connection.new(), collectionName, body)`
  """
  @spec update_collection(map() | Connection.t(), String.t() | map(), map() | keyword) ::
          {:ok, OpenApiTypesense.CollectionUpdateSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_collection(collectionName, body, opts) when is_binary(collectionName) do
    update_collection(Connection.new(), collectionName, body, opts)
  end

  def update_collection(conn, collectionName, body) when not is_struct(conn) and is_map(conn) do
    update_collection(Connection.new(conn), collectionName, body, [])
  end

  def update_collection(%Connection{} = conn, collectionName, body) when is_struct(conn) do
    update_collection(conn, collectionName, body, [])
  end

  @doc """
  Either one of:
  - `update_collection(%{api_key: 123, host: ...}, collectionName, body, opts)`
  - `update_collection(Connection.new(), collectionName, body, opts)`
  """
  @spec update_collection(map() | Connection.t(), String.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.CollectionUpdateSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_collection(conn, collectionName, body, opts)
      when not is_struct(conn) and is_map(conn) do
    update_collection(Connection.new(conn), collectionName, body, opts)
  end

  def update_collection(%Connection{} = conn, collectionName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, body: body],
      call: {OpenApiTypesense.Collections, :update_collection},
      url: "/collections/#{collectionName}",
      body: body,
      method: :patch,
      request: [{"application/json", {OpenApiTypesense.CollectionUpdateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CollectionUpdateSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a collection alias

  Create or update a collection alias. An alias is a virtual collection name that points to a real collection. If you're familiar with symbolic links on Linux, it's very similar to that. Aliases are useful when you want to reindex your data in the background on a new collection and switch your application to it without any changes to your code.

  ## Example
      iex> body = %{"collection_name" => "companies"}
      iex> OpenApiTypesense.Collections.upsert_alias("foo", body)

  """
  @spec upsert_alias(String.t(), map()) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_alias(aliasName, body) when is_binary(aliasName) do
    upsert_alias(Connection.new(), aliasName, body)
  end

  @doc """
  Either one of:
  - `upsert_alias(%{api_key: 123, host: ...}, aliasName, body)`
  - `upsert_alias(Connection.new(), aliasName, body)`
  - `upsert_alias(aliasName, body, opts)`
  """
  @spec upsert_alias(map() | Connection.t(), String.t(), map() | keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_alias(aliasName, body, opts) when is_binary(aliasName) do
    upsert_alias(Connection.new(), aliasName, body, opts)
  end

  def upsert_alias(conn, aliasName, body) when not is_struct(conn) and is_map(conn) do
    upsert_alias(Connection.new(conn), aliasName, body, [])
  end

  def upsert_alias(%Connection{} = conn, aliasName, body) when is_struct(conn) do
    upsert_alias(conn, aliasName, body, [])
  end

  @doc """
  Either one of:
  - `upsert_alias(%{api_key: 123, host: ...}, aliasName, body, opts)`
  - `upsert_alias(Connection.new(), aliasName, body, opts)`
  """
  @spec upsert_alias(map() | Connection.t(), String.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.CollectionAlias.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_alias(conn, aliasName, body, opts) when not is_struct(conn) and is_map(conn) do
    upsert_alias(Connection.new(conn), aliasName, body, opts)
  end

  def upsert_alias(%Connection{} = conn, aliasName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [aliasName: aliasName, body: body],
      call: {OpenApiTypesense.Collections, :upsert_alias},
      url: "/aliases/#{aliasName}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.CollectionAliasSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CollectionAlias, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
