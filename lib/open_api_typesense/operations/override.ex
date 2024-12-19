defmodule OpenApiTypesense.Override do
  @moduledoc """
  Provides API endpoint related to override
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

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
  @spec get_search_override(
          map() | Connection.t() | String.t(),
          String.t(),
          String.t() | keyword()
        ) ::
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
  @spec get_search_override(map() | Connection.t(), String.t(), String.t(), keyword()) ::
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
      call: {OpenApiTypesense.Override, :get_search_override},
      url: "/collections/#{collectionName}/overrides/#{overrideId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.SearchOverride, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
