defmodule OpenApiTypesense.Override do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoint related to override
  """

  @default_client OpenApiTypesense.Client

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
      call: {OpenApiTypesense.Override, :get_search_override},
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
end
