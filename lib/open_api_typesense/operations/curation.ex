defmodule OpenApiTypesense.Curation do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to curation
  """

  @default_client OpenApiTypesense.Client

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
      call: {OpenApiTypesense.Curation, :delete_search_override},
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
      call: {OpenApiTypesense.Curation, :get_search_overrides},
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
      call: {OpenApiTypesense.Curation, :upsert_search_override},
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
end
