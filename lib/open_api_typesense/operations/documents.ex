defmodule OpenApiTypesense.Documents do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to documents
  """

  defstruct [:num_deleted, :num_updated]

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a document

  Delete an individual document from a collection by using its ID.

  ## Options

    * `ignore_not_found`: Ignore the error and treat the deletion as success.

  """
  @doc since: "0.4.0"
  @spec delete_document(collection_name :: String.t(), document_id :: String.t(), opts :: keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_document(collection_name, document_id, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:ignore_not_found])

    client.request(%{
      args: [collection_name: collection_name, document_id: document_id],
      call: {OpenApiTypesense.Documents, :delete_document},
      url: "/collections/#{collection_name}/documents/#{document_id}",
      method: :delete,
      query: query,
      response: [
        {200, :map},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @type delete_documents_200_json_resp :: %{num_deleted: integer}

  @doc """
  Delete a bunch of documents

  Delete a bunch of documents that match a specific filter condition. Use the `batch_size` parameter to control the number of documents that should deleted at a time. A larger value will speed up deletions, but will impact performance of other operations running on the server.

  ## Options

    * `batch_size`: Batch size parameter controls the number of documents that should be deleted at a time. A larger value will speed up deletions, but will impact performance of other operations running on the server.
    * `filter_by`: Filter results by a particular value(s) or logical expressions. multiple conditions with &&.
    * `ignore_not_found`: To ignore an error and treat the deletion as success.
    * `truncate`: When true, removes all documents from the collection while preserving the collection and its schema.

  """
  @doc since: "0.4.0"
  @spec delete_documents(collection_name :: String.t(), opts :: keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_documents(collection_name, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:batch_size, :filter_by, :ignore_not_found, :truncate])

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Documents, :delete_documents},
      url: "/collections/#{collection_name}/documents",
      method: :delete,
      query: query,
      response: [
        {200, {OpenApiTypesense.Documents, :delete_documents_200_json_resp}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an override associated with a collection
  """
  @doc since: "0.4.0"
  @spec delete_search_override(
          collection_name :: String.t(),
          override_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collection_name, override_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, override_id: override_id],
      call: {OpenApiTypesense.Documents, :delete_search_override},
      url: "/collections/#{collection_name}/overrides/#{override_id}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.SearchOverrideDeleteResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Export all documents in a collection

  Export all documents in a collection in JSON lines format.

  ## Options

    * `filter_by`: Filter conditions for refining your search results. Separate multiple conditions with &&.
    * `include_fields`: List of fields from the document to include in the search result
    * `exclude_fields`: List of fields from the document to exclude in the search result

  """
  @doc since: "0.4.0"
  @spec export_documents(collection_name :: String.t(), opts :: keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def export_documents(collection_name, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:exclude_fields, :filter_by, :include_fields])

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Documents, :export_documents},
      url: "/collections/#{collection_name}/documents/export",
      method: :get,
      query: query,
      response: [
        {200, {:string, :generic}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a document

  Fetch an individual document from a collection by using its ID.

  ## Options

    * `include_fields`: List of fields that should be present in the returned document.
    * `exclude_fields`: List of fields that should not be present in the returned document.

  """
  @doc since: "0.4.0"
  @spec get_document(collection_name :: String.t(), document_id :: String.t(), opts :: keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_document(collection_name, document_id, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:exclude_fields, :include_fields])

    client.request(%{
      args: [collection_name: collection_name, document_id: document_id],
      call: {OpenApiTypesense.Documents, :get_document},
      url: "/collections/#{collection_name}/documents/#{document_id}",
      method: :get,
      query: query,
      response: [
        {200, :map},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a single search override

  Retrieve the details of a search override, given its id.
  """
  @doc since: "0.4.0"
  @spec get_search_override(
          collection_name :: String.t(),
          override_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_override(collection_name, override_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, override_id: override_id],
      call: {OpenApiTypesense.Documents, :get_search_override},
      url: "/collections/#{collection_name}/overrides/#{override_id}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all collection overrides

  ## Options

    * `limit`: Limit results in paginating on collection listing.
    * `offset`: Skip a certain number of results and start after that.

  """
  @doc since: "0.4.0"
  @spec get_search_overrides(collection_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_overrides(collection_name, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Documents, :get_search_overrides},
      url: "/collections/#{collection_name}/overrides",
      method: :get,
      query: query,
      response: [
        {200, {OpenApiTypesense.SearchOverridesResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Import documents into a collection

  The documents to be imported must be formatted in a newline delimited JSON structure. You can feed the output file from a Typesense export operation directly as import.

  ## Options

    * `batch_size`: Batch size parameter controls the number of documents that should be imported at a time. A larger value will speed up imports, but will impact performance of other operations running on the server.
    * `return_id`: Returning the id of the imported documents. If you want the import response to return the ingested document's id in the response, you can use the return_id parameter.
    * `remote_embedding_batch_size`: Max size of each batch that will be sent to remote APIs while importing multiple documents at once. Using lower amount will lower timeout risk, but increase number of requests made. Default is 200.
    * `remote_embedding_timeout_ms`: How long to wait until an API call to a remote embedding service is considered a timeout during indexing. Default is 60_000 ms
    * `remote_embedding_num_tries`: The number of times to retry an API call to a remote embedding service on failure during indexing. Default is 2.
    * `return_doc`: Returns the entire document back in response.
    * `action`: Additional action to perform
    * `dirty_values`: Dealing with Dirty Data

  """
  @doc since: "0.4.0"
  @spec import_documents(collection_name :: String.t(), body :: String.t(), opts :: keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_documents(collection_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    query =
      Keyword.take(opts, [
        :action,
        :batch_size,
        :dirty_values,
        :remote_embedding_batch_size,
        :remote_embedding_num_tries,
        :remote_embedding_timeout_ms,
        :return_doc,
        :return_id
      ])

    client.request(%{
      args: [collection_name: collection_name, body: body],
      call: {OpenApiTypesense.Documents, :import_documents},
      url: "/collections/#{collection_name}/documents/import",
      body: body,
      method: :post,
      query: query,
      request: [{"application/octet-stream", {:string, :generic}}],
      response: [
        {200, {:string, :generic}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
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
  @doc since: "0.4.0"
  @spec index_document(collection_name :: String.t(), body :: map, opts :: keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def index_document(collection_name, body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:action, :dirty_values])

    client.request(%{
      args: [collection_name: collection_name, body: body],
      call: {OpenApiTypesense.Documents, :index_document},
      url: "/collections/#{collection_name}/documents",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", :map}],
      response: [
        {201, :map},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  send multiple search requests in a single HTTP request

  This is especially useful to avoid round-trip network latencies incurred otherwise if each of these requests are sent in separate HTTP requests. You can also use this feature to do a federated search across multiple collections in a single HTTP request.

  ## Options

    * `limit_multi_searches`: Max number of search requests that can be sent in a multi-search request. Default 50
    * `x-typesense-api-key`: You can embed a separate search API key for each search within a multi_search request. This is useful when you want to apply different embedded filters for each collection in individual scoped API keys.

  """
  @doc since: "0.4.0"
  @spec multi_search(body :: OpenApiTypesense.MultiSearchSearchesParameter.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.MultiSearchResult.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def multi_search(body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit_multi_searches, :"x-typesense-api-key"])

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Documents, :multi_search},
      url: "/multi_search",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", {OpenApiTypesense.MultiSearchSearchesParameter, :t}}],
      response: [
        {200, {OpenApiTypesense.MultiSearchResult, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Search for documents in a collection

  Search for documents in a collection that match the search criteria.

  ## Options

    * `searchParameters` can be found here:
    https://typesense.org/docs/latest/api/search.html#search-parameters

  Either one of:
  - `search_collection(collectionName, params)`
  - `search_collection(%{api_key: xyz, host: ...}, collectionName, params)`
  - `search_collection(Connection.new(), collectionName, params)`

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
      iex> params = [q: "duplex", query_by: "house_type"]
      ...> OpenApiTypesense.Documents.search_collection("houses", params)

  """
  @doc since: "0.4.0"
  @spec search_collection(collection_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.SearchResult.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def search_collection(collection_name, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.drop(opts, [:conn])

    client.request(%{
      args: [collection_name: collection_name],
      call: {OpenApiTypesense.Documents, :search_collection},
      url: "/collections/#{collection_name}/documents/search",
      method: :get,
      query: query,
      response: [
        {200, {OpenApiTypesense.SearchResult, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
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
  @doc since: "0.4.0"
  @spec update_document(
          collection_name :: String.t(),
          document_id :: String.t(),
          body :: map,
          opts :: keyword
        ) :: {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_document(collection_name, document_id, body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:dirty_values])

    client.request(%{
      args: [collection_name: collection_name, document_id: document_id, body: body],
      call: {OpenApiTypesense.Documents, :update_document},
      url: "/collections/#{collection_name}/documents/#{document_id}",
      body: body,
      method: :patch,
      query: query,
      request: [{"application/json", :map}],
      response: [
        {200, :map},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @type update_documents_200_json_resp :: %{num_updated: integer}

  @doc """
  Update documents with conditional query

  The filter_by query parameter is used to filter to specify a condition against which the documents are matched. The request body contains the fields that should be updated for any documents that match the filter condition. This endpoint is only available if the Typesense server is version `0.25.0.rc12` or later.

  ## Options

    * `filter_by`: Filter results by a particular value(s) or logical expressions. multiple conditions with &&.
    * `action`: Additional action to perform

  """
  @doc since: "0.4.0"
  @spec update_documents(collection_name :: String.t(), body :: map, opts :: keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_documents(collection_name, body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:action, :filter_by])

    client.request(%{
      args: [collection_name: collection_name, body: body],
      call: {OpenApiTypesense.Documents, :update_documents},
      url: "/collections/#{collection_name}/documents",
      body: body,
      method: :patch,
      query: query,
      request: [{"application/json", :map}],
      response: [
        {200, {OpenApiTypesense.Documents, :update_documents_200_json_resp}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update an override to promote certain documents over others

  Create or update an override to promote certain documents over others. Using overrides, you can include or exclude specific documents for a given query.
  """
  @doc since: "0.4.0"
  @spec upsert_search_override(
          collection_name :: String.t(),
          override_id :: String.t(),
          body :: OpenApiTypesense.SearchOverrideSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(collection_name, override_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [collection_name: collection_name, override_id: override_id, body: body],
      call: {OpenApiTypesense.Documents, :upsert_search_override},
      url: "/collections/#{collection_name}/overrides/#{override_id}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.SearchOverrideSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
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
