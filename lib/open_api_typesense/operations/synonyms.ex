defmodule OpenApiTypesense.Synonyms do
  @moduledoc """
  Provides API endpoints related to synonyms
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a synonym associated with a collection
  """
  @spec delete_search_synonym(String.t(), String.t()) ::
          {:ok, OpenApiTypesense.SearchSynonymDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_synonym(collectionName, synonymId) do
    delete_search_synonym(Connection.new(), collectionName, synonymId, [])
  end

  @doc """
  Either one of:
  - `delete_search_synonym(collectionName, synonymId, opts)`
  - `delete_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId)`
  - `delete_search_synonym(Connection.new(), collectionName, synonymId)`
  """
  @spec delete_search_synonym(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchSynonymDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_synonym(collectionName, synonymId, opts)
      when is_list(opts) and is_binary(collectionName) do
    delete_search_synonym(Connection.new(), collectionName, synonymId, opts)
  end

  def delete_search_synonym(conn, collectionName, synonymId) do
    delete_search_synonym(conn, collectionName, synonymId, [])
  end

  @doc """
  Either one of:
  - `delete_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId, opts)`
  - `delete_search_synonym(Connection.new(), collectionName, synonymId, opts)`
  """
  @spec delete_search_synonym(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchSynonymDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_synonym(conn, collectionName, synonymId, opts)
      when not is_struct(conn) and is_map(conn) do
    delete_search_synonym(Connection.new(conn), collectionName, synonymId, opts)
  end

  def delete_search_synonym(%Connection{} = conn, collectionName, synonymId, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec get_search_synonym(String.t(), String.t()) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonym(collectionName, synonymId) do
    get_search_synonym(Connection.new(), collectionName, synonymId, [])
  end

  @doc """
  Either one of:
  - `get_search_synonym(collectionName, synonymId, opts)`
  - `get_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId)`
  - `get_search_synonym(Connection.new(), collectionName, synonymId)`
  """
  @spec get_search_synonym(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonym(collectionName, synonymId, opts)
      when is_list(opts) and is_binary(collectionName) do
    get_search_synonym(Connection.new(), collectionName, synonymId, opts)
  end

  def get_search_synonym(conn, collectionName, synonymId) do
    get_search_synonym(conn, collectionName, synonymId, [])
  end

  @doc """
  Either one of:
  - `get_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId, opts)`
  - `get_search_synonym(Connection.new(), collectionName, synonymId, opts)`
  """
  @spec get_search_synonym(map() | Connection.t(), String.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonym(conn, collectionName, synonymId, opts)
      when not is_struct(conn) and is_map(conn) do
    get_search_synonym(Connection.new(conn), collectionName, synonymId, opts)
  end

  def get_search_synonym(%Connection{} = conn, collectionName, synonymId, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec get_search_synonyms(String.t()) ::
          {:ok, OpenApiTypesense.SearchSynonymsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonyms(collectionName) do
    get_search_synonyms(Connection.new(), collectionName, [])
  end

  @doc """
  Either one of:
  - `get_search_synonyms(collectionName, opts)`
  - `get_search_synonyms(%{api_key: xyz, host: ...}, collectionName)`
  - `get_search_synonyms(Connection.new(), collectionName)`
  """
  @spec get_search_synonyms(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.SearchSynonymsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonyms(collectionName, opts)
      when is_list(opts) and is_binary(collectionName) do
    get_search_synonyms(Connection.new(), collectionName, opts)
  end

  def get_search_synonyms(conn, collectionName) do
    get_search_synonyms(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `get_search_synonyms(%{api_key: xyz, host: ...}, collectionName, opts)`
  - `get_search_synonyms(Connection.new(), collectionName, opts)`
  """
  @spec get_search_synonyms(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.SearchSynonymsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_synonyms(conn, collectionName, opts) when not is_struct(conn) and is_map(conn) do
    get_search_synonyms(Connection.new(conn), collectionName, opts)
  end

  def get_search_synonyms(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(conn, %{
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
  @spec upsert_search_synonym(String.t(), String.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_synonym(collectionName, synonymId, body) do
    upsert_search_synonym(Connection.new(), collectionName, synonymId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_search_synonym(collectionName, synonymId, body, opts)`
  - `upsert_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId, body)`
  - `upsert_search_synonym(Connection.new(), collectionName, synonymId, body)`
  """
  @spec upsert_search_synonym(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | map(),
          map() | keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_synonym(collectionName, synonymId, body, opts)
      when is_list(opts) and is_binary(collectionName) do
    upsert_search_synonym(Connection.new(), collectionName, synonymId, body, opts)
  end

  def upsert_search_synonym(conn, collectionName, synonymId, body) do
    upsert_search_synonym(conn, collectionName, synonymId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_search_synonym(%{api_key: xyz, host: ...}, collectionName, synonymId, body, opts)`
  - `upsert_search_synonym(Connection.new(), collectionName, synonymId, body, opts)`
  """
  @spec upsert_search_synonym(map() | Connection.t(), String.t(), String.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.SearchSynonym.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_synonym(conn, collectionName, synonymId, body, opts)
      when not is_struct(conn) and is_map(conn) do
    upsert_search_synonym(Connection.new(conn), collectionName, synonymId, body, opts)
  end

  def upsert_search_synonym(%Connection{} = conn, collectionName, synonymId, body, opts)
      when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
