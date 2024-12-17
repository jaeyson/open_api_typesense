defmodule OpenApiTypesense.Documents do
  @moduledoc """
  Provides API endpoints related to documents
  """

  alias OpenApiTypesense.Connection

  defstruct [:num_deleted, :num_updated]

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a document

  Delete an individual document from a collection by using its ID.
  """
  @spec delete_document(String.t(), String.t()) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_document(collectionName, documentId) do
    delete_document(Connection.new(), collectionName, documentId, [])
  end

  @doc """
  Either one of:
  - `delete_document(collectionName, documentId, opts)`
  - `delete_document(%{api_key: xyz, host: ...}, collectionName, documentId)`
  - `delete_document(Connection.new(), collectionName, documentId)`
  """
  @spec delete_document(map() | Connection.t() | String.t(), String.t(), String.t() | keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_document(collectionName, documentId, opts) when is_binary(collectionName) do
    delete_document(Connection.new(), collectionName, documentId, opts)
  end

  def delete_document(conn, collectionName, documentId)
      when not is_struct(conn) and is_map(conn) do
    delete_document(Connection.new(conn), collectionName, documentId, [])
  end

  def delete_document(%Connection{} = conn, collectionName, documentId) when is_struct(conn) do
    delete_document(conn, collectionName, documentId, [])
  end

  @doc """
  Either one of:
  - `delete_document(%{api_key: xyz, host: ...}, collectionName, documentId, opts)`
  - `delete_document(Connection.new(), collectionName, documentId, opts)`
  """
  @spec delete_document(map() | Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_document(conn, collectionName, documentId, opts)
      when not is_struct(conn) and is_map(conn) do
    delete_document(Connection.new(conn), collectionName, documentId, opts)
  end

  def delete_document(%Connection{} = conn, collectionName, documentId, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, documentId: documentId],
      call: {OpenApiTypesense.Documents, :delete_document},
      url: "/collections/#{collectionName}/documents/#{documentId}",
      method: :delete,
      response: [{200, :map}, {404, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @type delete_documents_200_json_resp :: %{num_deleted: integer}

  @doc """
  Delete a bunch of documents

  Delete a bunch of documents that match a specific filter condition. Use the `batch_size` parameter to control the number of documents that should deleted at a time. A larger value will speed up deletions, but will impact performance of other operations running on the server.

  ## Options

    * `deleteDocumentsParameters`

  """
  @spec delete_documents(String.t()) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_documents(collectionName) do
    delete_documents(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `delete_documents(collectionName, opts)`
  - `delete_documents(%{api_key: xyz, host: ...}, collectionName)`
  - `delete_documents(Connection.new(), collectionName)`
  """
  @spec delete_documents(map() | Connection.t() | String.t(), String.t() | keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_documents(collectionName, opts) when is_binary(collectionName) do
    delete_documents(Connection.new(), collectionName, opts)
  end

  def delete_documents(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    delete_documents(Connection.new(conn), collectionName, [])
  end

  def delete_documents(%Connection{} = conn, collectionName) when is_struct(conn) do
    delete_documents(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `delete_document(%{api_key: xyz, host: ...}, collectionName, documentId, opts)`
  - `delete_document(Connection.new(), collectionName, documentId, opts)`
  """
  @spec delete_documents(map() | Connection.t(), String.t(), keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_documents(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    delete_documents(Connection.new(conn), collectionName, opts)
  end

  def delete_documents(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:deleteDocumentsParameters])

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Documents, :delete_documents},
      url: "/collections/#{collectionName}/documents",
      method: :delete,
      query: query,
      response: [
        {200, {OpenApiTypesense.Documents, :delete_documents_200_json_resp}},
        {404, {OpenApiTypesense.ApiResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an override associated with a collection
  """
  @spec delete_search_override(String.t(), String.t()) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collectionName, overrideId) do
    delete_search_override(Connection.new(), collectionName, overrideId)
  end

  @doc """
  Either one of:
  - `delete_documents(collectionName, opts)`
  - `delete_documents(%{api_key: xyz, host: ...}, collectionName)`
  - `delete_documents(Connection.new(), collectionName)`
  """
  @spec delete_search_override(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collectionName, overrideId, opts) when is_binary(collectionName) do
    delete_search_override(Connection.new(), collectionName, overrideId, opts)
  end

  def delete_search_override(conn, collectionName, overrideId)
      when not is_struct(conn) and is_map(conn) do
    delete_search_override(Connection.new(conn), collectionName, overrideId, [])
  end

  def delete_search_override(%Connection{} = conn, collectionName, overrideId)
      when is_struct(conn) do
    delete_search_override(conn, collectionName, overrideId, [])
  end

  @doc """
  Either one of:
  - `delete_documents(%{api_key: xyz, host: ...}, collectionName, opts)`
  - `delete_documents(Connection.new(), collectionName, opts)`
  """
  @spec delete_search_override(map() | Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(conn, collectionName, overrideId, opts)
      when not is_struct(conn) and is_map(conn) do
    delete_search_override(Connection.new(conn), collectionName, overrideId, opts)
  end

  def delete_search_override(%Connection{} = conn, collectionName, overrideId, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId],
      call: {OpenApiTypesense.Documents, :delete_search_override},
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
  Export all documents in a collection

  Export all documents in a collection in JSON lines format.

  ## Options

    * `exportDocumentsParameters`

  """
  @spec export_documents(String.t()) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def export_documents(collectionName) do
    export_documents(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `export_documents(collectionName, opts)`
  - `export_documents(%{api_key: xyz, host: ...}, collectionName)`
  - `export_documents(Connection.new(), collectionName)`
  """
  @spec export_documents(map() | Connection.t() | String.t(), String.t() | keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def export_documents(collectionName, opts) when is_binary(collectionName) do
    export_documents(Connection.new(), collectionName, opts)
  end

  def export_documents(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    export_documents(Connection.new(conn), collectionName, [])
  end

  def export_documents(%Connection{} = conn, collectionName) when is_struct(conn) do
    export_documents(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `export_documents(%{api_key: xyz, host: ...}, collectionName, opts)`
  - `export_documents(Connection.new(), collectionName, opts)`
  """
  @spec export_documents(map() | Connection.t(), String.t(), keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def export_documents(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    export_documents(Connection.new(conn), collectionName, opts)
  end

  def export_documents(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:exportDocumentsParameters])

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Documents, :export_documents},
      url: "/collections/#{collectionName}/documents/export",
      method: :get,
      query: query,
      response: [{200, {:string, :generic}}, {404, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Retrieve a document

  Fetch an individual document from a collection by using its ID.
  """
  @spec get_document(String.t(), String.t()) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_document(collectionName, documentId) do
    get_document(Connection.new(), collectionName, documentId)
  end

  @doc """
  Either one of:
  - `get_document(collectionName, documentId, opts)`
  - `get_document(%{api_key: xyz, host: ...}, collectionName, documentId)`
  - `get_document(Connection.new(), collectionName, documentId)`
  """
  @spec get_document(map() | Connection.t() | String.t(), String.t(), String.t() | keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_document(collectionName, documentId, opts) when is_binary(collectionName) do
    get_document(Connection.new(), collectionName, documentId, opts)
  end

  def get_document(conn, collectionName, documentId) when not is_struct(conn) and is_map(conn) do
    get_document(Connection.new(conn), collectionName, documentId, [])
  end

  def get_document(%Connection{} = conn, collectionName, documentId) when is_struct(conn) do
    get_document(conn, collectionName, documentId, [])
  end

  @doc """
  Either one of:
  - `get_document(%{api_key: xyz, host: ...}, collectionName, documentId, opts)`
  - `get_document(Connection.new(), collectionName, documentId, opts)`
  """
  @spec get_document(map() | Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_document(conn, collectionName, documentId, opts)
      when not is_struct(conn) and is_map(conn) do
    get_document(Connection.new(conn), collectionName, documentId, opts)
  end

  def get_document(%Connection{} = conn, collectionName, documentId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, documentId: documentId],
      call: {OpenApiTypesense.Documents, :get_document},
      url: "/collections/#{collectionName}/documents/#{documentId}",
      method: :get,
      response: [{200, :map}, {404, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Retrieve a single search override

  Retrieve the details of a search override, given its id.
  """
  @spec get_search_override(String.t(), String.t()) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | :error
  def get_search_override(collectionName, overrideId) do
    get_search_override(Connection.new(), collectionName, overrideId)
  end

  @doc """
  Either one of:
  - `get_search_override(collectionName, overrideId, opts)`
  - `get_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId)`
  - `get_search_override(Connection.new(), collectionName, overrideId)`
  """
  @spec get_search_override(map() | Connection.t() | String.t(), String.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | :error
  def get_search_override(collectionName, overrideId, opts) when is_binary(collectionName) do
    get_search_override(Connection.new(), collectionName, overrideId, opts)
  end

  def get_search_override(conn, collectionName, overrideId)
      when not is_struct(conn) and is_map(conn) do
    get_search_override(Connection.new(conn), collectionName, overrideId, [])
  end

  def get_search_override(%Connection{} = conn, collectionName, overrideId)
      when is_struct(conn) do
    get_search_override(conn, collectionName, overrideId, [])
  end

  @doc """
  Either one of:
  - `get_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, opts)`
  - `get_search_override(Connection.new(), collectionName, overrideId, opts)`
  """
  @spec get_search_override(map() | Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | :error
  def get_search_override(conn, collectionName, overrideId, opts)
      when not is_struct(conn) and is_map(conn) do
    get_search_override(Connection.new(conn), collectionName, overrideId, opts)
  end

  def get_search_override(%Connection{} = conn, collectionName, overrideId, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId],
      call: {OpenApiTypesense.Documents, :get_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all collection overrides
  """
  @spec get_search_overrides(String.t()) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(collectionName) do
    get_search_overrides(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `get_search_overrides(collectionName, opts)`
  - `get_search_overrides(%{api_key: xyz, host: ...}, collectionName)`
  - `get_search_overrides(Connection.new(), collectionName)`
  """
  @spec get_search_overrides(map() | Connection.t() | String.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(collectionName, opts) when is_binary(collectionName) do
    get_search_overrides(Connection.new(), collectionName, opts)
  end

  def get_search_overrides(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    get_search_overrides(Connection.new(conn), collectionName, [])
  end

  def get_search_overrides(%Connection{} = conn, collectionName) when is_struct(conn) do
    get_search_overrides(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `get_search_overrides(%{api_key: xyz, host: ...}, collectionName, opts)`
  - `get_search_overrides(Connection.new(), collectionName, opts)`
  """
  @spec get_search_overrides(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()} | :error
  def get_search_overrides(conn, collectionName, opts)
      when not is_struct(conn) and is_map(conn) do
    get_search_overrides(Connection.new(conn), collectionName, opts)
  end

  def get_search_overrides(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Documents, :get_search_overrides},
      url: "/collections/#{collectionName}/overrides",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchOverridesResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Import documents into a collection

  The documents to be imported must be formatted in a newline delimited JSON structure. You can feed the output file from a Typesense export operation directly as import.

  ## Options

    * `importDocumentsParameters`

  """
  @spec import_documents(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_documents(collectionName, body) do
    import_documents(Connection.new(), collectionName, body)
  end

  @doc """
  Either one of:
  - `import_documents(collectionName, payload, opts)`
  - `import_documents(%{api_key: xyz, host: ...}, collectionName, payload)`
  - `import_documents(Connection.new(), collectionName, payload)`
  """
  @spec import_documents(map() | Connection.t() | String.t(), String.t(), String.t() | keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_documents(collectionName, body, opts) when is_binary(collectionName) do
    import_documents(Connection.new(), collectionName, body, opts)
  end

  def import_documents(conn, collectionName, body) when not is_struct(conn) and is_map(conn) do
    import_documents(Connection.new(conn), collectionName, body, [])
  end

  def import_documents(%Connection{} = conn, collectionName, body) when is_struct(conn) do
    import_documents(conn, collectionName, body, [])
  end

  @doc """
  Either one of:
  - `import_documents(%{api_key: xyz, host: ...}, collectionName, payload, opts)`
  - `import_documents(Connection.new(), collectionName, payload, opts)`
  """
  @spec import_documents(map() | Connection.t(), String.t(), String.t(), keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_documents(conn, collectionName, body, opts)
      when not is_struct(conn) and is_map(conn) do
    import_documents(Connection.new(conn), collectionName, body, opts)
  end

  def import_documents(%Connection{} = conn, collectionName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:importDocumentsParameters])

    client.request(conn, %{
      args: [collectionName: collectionName, body: body],
      call: {OpenApiTypesense.Documents, :import_documents},
      url: "/collections/#{collectionName}/documents/import",
      body: body,
      method: :post,
      query: query,
      request: [{"application/octet-stream", {:string, :generic}}],
      response: [
        {200, {:string, :generic}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Index a document

  A document to be indexed in a given collection must conform to the schema of the collection.

  ## Options

    * `action`: Additional action to perform
    * `dirty_values`: Dealing with Dirty Data

  """
  @spec index_document(String.t(), map) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def index_document(collectionName, body) do
    index_document(Connection.new(), collectionName, body)
  end

  @doc """
  Either one of:
  - `index_document(collectionName, payload, opts)`
  - `index_document(%{api_key: xyz, host: ...}, collectionName, payload)`
  - `index_document(Connection.new(), collectionName, payload)`
  """
  @spec index_document(map() | Connection.t() | String.t(), String.t() | map, map() | keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def index_document(collectionName, body, opts) when is_binary(collectionName) do
    index_document(Connection.new(), collectionName, body, opts)
  end

  def index_document(conn, collectionName, body) when not is_struct(conn) and is_map(conn) do
    index_document(Connection.new(conn), collectionName, body, [])
  end

  def index_document(%Connection{} = conn, collectionName, body) when is_struct(conn) do
    index_document(conn, collectionName, body, [])
  end

  @doc """
  Either one of:
  - `index_document(%{api_key: xyz, host: ...}, collectionName, payload, opts)`
  - `index_document(Connection.new(), collectionName, payload, opts)`
  """
  @spec index_document(map() | Connection.t(), String.t(), map, keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def index_document(conn, collectionName, body, opts)
      when not is_struct(conn) and is_map(conn) do
    index_document(Connection.new(conn), collectionName, body, opts)
  end

  def index_document(%Connection{} = conn, collectionName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:action, :dirty_values])

    client.request(conn, %{
      args: [collectionName: collectionName, body: body],
      call: {OpenApiTypesense.Documents, :index_document},
      url: "/collections/#{collectionName}/documents",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", :map}],
      response: [{201, :map}, {404, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  send multiple search requests in a single HTTP request

  This is especially useful to avoid round-trip network latencies incurred otherwise if each of these requests are sent in separate HTTP requests. You can also use this feature to do a federated search across multiple collections in a single HTTP request.

  ## Options

    * `multiSearchParameters`

  """
  @spec multi_search(OpenApiTypesense.MultiSearchSearchesParameter.t()) ::
          {:ok, OpenApiTypesense.MultiSearchResult.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def multi_search(body) do
    multi_search(Connection.new(), body)
  end

  @doc """
  Either one of:
  - `multi_search(payload, opts)`
  - `multi_search(%{api_key: xyz, host: ...}, payload)`
  - `multi_search(Connection.new(), payload)`
  """
  @spec multi_search(map() | Connection.t(), map() | keyword) ::
          {:ok, OpenApiTypesense.MultiSearchResult.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def multi_search(body, opts) when is_list(opts) do
    multi_search(Connection.new(), body, opts)
  end

  def multi_search(conn, body) when not is_struct(conn) and is_map(conn) and is_map(body) do
    multi_search(Connection.new(conn), body, [])
  end

  def multi_search(%Connection{} = conn, body) when is_struct(conn) do
    multi_search(conn, body)
  end

  @doc """
  Either one of:
  - `multi_search(%{api_key: xyz, host: ...}, payload, opts)`
  - `multi_search(Connection.new(), payload, opts)`
  """
  @spec multi_search(map() | Connection.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.MultiSearchResult.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def multi_search(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    multi_search(Connection.new(conn), body, opts)
  end

  def multi_search(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:multiSearchParameters])

    client.request(conn, %{
      args: [body: body],
      call: {OpenApiTypesense.Documents, :multi_search},
      url: "/multi_search",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", {OpenApiTypesense.MultiSearchSearchesParameter, :t}}],
      response: [
        {200, {OpenApiTypesense.MultiSearchResult, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Search for documents in a collection

  Search for documents in a collection that match the search criteria.

  ## Options

    * `searchParameters`

  """
  @spec search_collection(String.t()) ::
          {:ok, OpenApiTypesense.SearchResult.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def search_collection(collectionName) do
    search_collection(Connection.new(), collectionName)
  end

  @doc """
  Either one of:
  - `search_collection(payload, opts)`
  - `search_collection(%{api_key: xyz, host: ...}, payload)`
  - `search_collection(Connection.new(), payload)`
  """
  @spec search_collection(map() | Connection.t() | String.t(), String.t() | keyword) ::
          {:ok, OpenApiTypesense.SearchResult.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def search_collection(collectionName, opts) when is_binary(collectionName) do
    search_collection(Connection.new(), collectionName, opts)
  end

  def search_collection(conn, collectionName) when not is_struct(conn) and is_map(conn) do
    search_collection(Connection.new(conn), collectionName, [])
  end

  def search_collection(%Connection{} = conn, collectionName) when is_struct(conn) do
    search_collection(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `search_collection(%{api_key: xyz, host: ...}, payload, opts)`
  - `search_collection(Connection.new(), payload, opts)`
  """
  @spec search_collection(map() | Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.SearchResult.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def search_collection(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    search_collection(Connection.new(conn), collectionName, opts)
  end

  def search_collection(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:searchParameters])

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Documents, :search_collection},
      url: "/collections/#{collectionName}/documents/search",
      method: :get,
      query: query,
      response: [
        {200, {OpenApiTypesense.SearchResult, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update a document

  Update an individual document from a collection by using its ID. The update can be partial.

  ## Options

    * `dirty_values`: Dealing with Dirty Data

  """
  @spec update_document(String.t(), String.t(), map) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_document(collectionName, documentId, body) do
    update_document(Connection.new(), collectionName, documentId, body)
  end

  @doc """
  Either one of:
  - `update_document(collectionName, documentId, opts)`
  - `update_document(%{api_key: xyz, host: ...}, collectionName, documentId)`
  - `update_document(Connection.new(), collectionName, documentId)`
  """
  @spec update_document(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | map(),
          map() | keyword
        ) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_document(collectionName, documentId, body, opts) when is_binary(collectionName) do
    update_document(Connection.new(), collectionName, documentId, body, opts)
  end

  def update_document(conn, collectionName, documentId, body)
      when not is_struct(conn) and is_map(conn) do
    update_document(Connection.new(conn), collectionName, documentId, body, [])
  end

  def update_document(%Connection{} = conn, collectionName, documentId, body)
      when is_struct(conn) do
    update_document(conn, collectionName, documentId, body, [])
  end

  @doc """
  Either one of:
  - `update_document(%{api_key: xyz, host: ...}, collectionName, documentId, opts)`
  - `update_document(Connection.new(), collectionName, documentId, opts)`
  """
  @spec update_document(map() | Connection.t(), String.t(), String.t(), map, keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_document(conn, collectionName, documentId, body, opts)
      when not is_struct(conn) and is_map(conn) do
    update_document(Connection.new(conn), collectionName, documentId, body, opts)
  end

  def update_document(%Connection{} = conn, collectionName, documentId, body, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:dirty_values])

    client.request(conn, %{
      args: [collectionName: collectionName, documentId: documentId, body: body],
      call: {OpenApiTypesense.Documents, :update_document},
      url: "/collections/#{collectionName}/documents/#{documentId}",
      body: body,
      method: :patch,
      query: query,
      request: [{"application/json", :map}],
      response: [{200, :map}, {404, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @type update_documents_200_json_resp :: %{num_updated: integer}

  @doc """
  Update documents with conditional query

  The filter_by query parameter is used to filter to specify a condition against which the documents are matched. The request body contains the fields that should be updated for any documents that match the filter condition. This endpoint is only available if the Typesense server is version `0.25.0.rc12` or later.

  ## Options

    * `updateDocumentsParameters`

  """
  @spec update_documents(String.t(), map) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_documents(collectionName, body) do
    update_documents(Connection.new(), collectionName, body)
  end

  @doc """
  Either one of:
  - `update_documents(collectionName, payload, opts)`
  - `update_document(%{api_key: xyz, host: ...}, collectionName, payload)`
  - `update_document(Connection.new(), collectionName, payload)`
  """
  @spec update_documents(map() | Connection.t() | String.t(), String.t() | map(), map() | keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_documents(collectionName, body, opts) when is_binary(collectionName) do
    update_documents(Connection.new(), collectionName, body, opts)
  end

  def update_documents(conn, collectionName, body) when not is_struct(conn) and is_map(conn) do
    update_documents(Connection.new(conn), collectionName, body, [])
  end

  def update_documents(%Connection{} = conn, collectionName, body) when is_struct(conn) do
    update_documents(conn, collectionName, body, [])
  end

  @doc """
  Either one of:
  - `update_documents(%{api_key: xyz, host: ...}, collectionName, payload, opts)`
  - `update_documents(Connection.new(), collectionName, payload, opts)`
  """
  @spec update_documents(map() | Connection.t(), String.t(), map, keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_documents(conn, collectionName, body, opts)
      when not is_struct(conn) and is_map(conn) do
    update_documents(Connection.new(conn), collectionName, body, opts)
  end

  def update_documents(%Connection{} = conn, collectionName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:updateDocumentsParameters])

    client.request(conn, %{
      args: [collectionName: collectionName, body: body],
      call: {OpenApiTypesense.Documents, :update_documents},
      url: "/collections/#{collectionName}/documents",
      body: body,
      method: :patch,
      query: query,
      request: [{"application/json", :map}],
      response: [
        {200, {OpenApiTypesense.Documents, :update_documents_200_json_resp}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update an override to promote certain documents over others

  Create or update an override to promote certain documents over others. Using overrides, you can include or exclude specific documents for a given query.
  """
  @spec upsert_search_override(String.t(), String.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(collectionName, overrideId, body) do
    upsert_search_override(Connection.new(), collectionName, overrideId, body)
  end

  @doc """
  Either one of:
  - `upsert_search_override(collectionName, overrideId, payload, opts)`
  - `upsert_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, payload)`
  - `upsert_search_override(Connection.new(), collectionName, overrideId, payload)`
  """
  @spec upsert_search_override(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | map(),
          map() | keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(collectionName, overrideId, body, opts)
      when is_binary(collectionName) do
    upsert_search_override(Connection.new(), collectionName, overrideId, body, opts)
  end

  def upsert_search_override(conn, collectionName, overrideId, body)
      when not is_struct(conn) and is_map(conn) do
    upsert_search_override(Connection.new(conn), collectionName, overrideId, body, [])
  end

  def upsert_search_override(%Connection{} = conn, collectionName, overrideId, body)
      when is_struct(conn) do
    upsert_search_override(conn, collectionName, overrideId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, payload, opts)`
  - `upsert_search_override(Connection.new(), collectionName, overrideId, payload, opts)`
  """
  @spec upsert_search_override(map() | Connection.t(), String.t(), String.t(), map(), keyword) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(conn, collectionName, overrideId, body, opts)
      when not is_struct(conn) and is_map(conn) do
    upsert_search_override(Connection.new(conn), collectionName, overrideId, body, opts)
  end

  def upsert_search_override(%Connection{} = conn, collectionName, overrideId, body, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [collectionName: collectionName, overrideId: overrideId, body: body],
      call: {OpenApiTypesense.Documents, :upsert_search_override},
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

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(:delete_documents_200_json_resp) do
    [num_deleted: :integer]
  end

  def __fields__(:update_documents_200_json_resp) do
    [num_updated: :integer]
  end
end
