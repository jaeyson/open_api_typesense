defmodule OpenApiTypesense.Curation do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to curation
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete an override associated with a collection
  """
  @doc since: "0.4.0"
  @spec delete_search_override(String.t(), String.t()) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collectionName, overrideId) do
    delete_search_override(collectionName, overrideId, [])
  end

  @doc """
  Either one of:
  - `delete_search_override(collectionName, overrideId, opts)`
  - `delete_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId)`
  - `delete_search_override(Connection.new(), collectionName, overrideId)`
  """
  @doc since: "0.4.0"
  @spec delete_search_override(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchOverrideDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_search_override(collectionName, overrideId, opts)
      when is_list(opts) and is_binary(collectionName) do
    delete_search_override(Connection.new(), collectionName, overrideId, opts)
  end

  def delete_search_override(conn, collectionName, overrideId) do
    delete_search_override(conn, collectionName, overrideId, [])
  end

  @doc """
  Either one of:
  - `delete_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, opts)`
  - `delete_search_override(Connection.new(), collectionName, overrideId, opts)`
  """
  @doc since: "0.4.0"
  @spec delete_search_override(map() | Connection.t(), String.t(), String.t(), keyword()) ::
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
      call: {OpenApiTypesense.Curation, :delete_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
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
  List all collection overrides

  ## Options

    * `limit`: Limit results in paginating on collection listing.
    * `offset`: Skip a certain number of results and start after that.

  """
  @doc since: "0.4.0"
  @spec get_search_overrides(String.t()) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_overrides(collectionName) do
    get_search_overrides(collectionName, [])
  end

  @doc """
  Either one of:
  - `get_search_overrides(collectionName, opts)`
  - `get_search_overrides(%{api_key: xyz, host: ...}, collectionName)`
  - `get_search_overrides(Connection.new(), collectionName)`
  """
  @doc since: "0.4.0"
  @spec get_search_overrides(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_overrides(collectionName, opts)
      when is_list(opts) and is_binary(collectionName) do
    get_search_overrides(Connection.new(), collectionName, opts)
  end

  def get_search_overrides(conn, collectionName) do
    get_search_overrides(conn, collectionName, [])
  end

  @doc """
  Either one of:
  - `get_search_overrides(%{api_key: xyz, host: ...}, collectionName, opts)`
  - `get_search_overrides(Connection.new(), collectionName, opts)`
  """
  @doc since: "0.4.0"
  @spec get_search_overrides(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.SearchOverridesResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_search_overrides(conn, collectionName, opts)
      when not is_struct(conn) and is_map(conn) do
    get_search_overrides(Connection.new(conn), collectionName, opts)
  end

  def get_search_overrides(%Connection{} = conn, collectionName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(conn, %{
      args: [collectionName: collectionName],
      call: {OpenApiTypesense.Curation, :get_search_overrides},
      url: "/collections/#{collectionName}/overrides",
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
  Create or update an override to promote certain documents over others

  Create or update an override to promote certain documents over others. Using overrides, you can include or exclude specific documents for a given query.
  """
  @doc since: "0.4.0"
  @spec upsert_search_override(String.t(), String.t(), map()) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(collectionName, overrideId, body) do
    upsert_search_override(collectionName, overrideId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_search_override(collectionName, overrideId, body, opts)`
  - `upsert_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, body)`
  - `upsert_search_override(Connection.new(), collectionName, overrideId, body)`
  """
  @doc since: "0.4.0"
  @spec upsert_search_override(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | map(),
          map() | keyword()
        ) ::
          {:ok, OpenApiTypesense.SearchOverride.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_search_override(collectionName, overrideId, body, opts)
      when is_list(opts) and is_binary(collectionName) do
    upsert_search_override(Connection.new(), collectionName, overrideId, body, opts)
  end

  def upsert_search_override(conn, collectionName, overrideId, body) do
    upsert_search_override(conn, collectionName, overrideId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_search_override(%{api_key: xyz, host: ...}, collectionName, overrideId, body, opts)`
  - `upsert_search_override(Connection.new(), collectionName, overrideId, body, opts)`
  """
  @doc since: "0.4.0"
  @spec upsert_search_override(map() | Connection.t(), String.t(), String.t(), map(), keyword()) ::
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
      call: {OpenApiTypesense.Curation, :upsert_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
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
end
