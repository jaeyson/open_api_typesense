defmodule OpenApiTypesense.CurationSets do
  @moduledoc since: "1.2.0"

  @moduledoc """
  Provides API endpoints related to curation sets
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a curation set

  Delete a specific curation set by its name
  """
  @doc since: "1.2.0"
  @spec delete_curation_set(curation_set_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CurationSetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_curation_set(curation_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name],
      call: {OpenApiTypesense.CurationSets, :delete_curation_set},
      url: "/curation_sets/#{curation_set_name}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CurationSetDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a curation set item

  Delete a specific curation item by its id
  """
  @doc since: "1.2.0"
  @spec delete_curation_set_item(
          curation_set_name :: String.t(),
          item_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CurationItemDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_curation_set_item(curation_set_name, item_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name, item_id: item_id],
      call: {OpenApiTypesense.CurationSets, :delete_curation_set_item},
      url: "/curation_sets/#{curation_set_name}/items/#{item_id}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.CurationItemDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a curation set

  Retrieve a specific curation set by its name
  """
  @doc since: "1.2.0"
  @spec retrieve_curation_set(curation_set_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.CurationSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_curation_set(curation_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name],
      call: {OpenApiTypesense.CurationSets, :retrieve_curation_set},
      url: "/curation_sets/#{curation_set_name}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CurationSetSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a curation set item

  Retrieve a specific curation item by its id
  """
  @doc since: "1.2.0"
  @spec retrieve_curation_set_item(
          curation_set_name :: String.t(),
          item_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CurationItemSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_curation_set_item(curation_set_name, item_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name, item_id: item_id],
      call: {OpenApiTypesense.CurationSets, :retrieve_curation_set_item},
      url: "/curation_sets/#{curation_set_name}/items/#{item_id}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.CurationItemSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List items in a curation set

  Retrieve all curation items in a set
  """
  @doc since: "1.2.0"
  @spec retrieve_curation_set_items(curation_set_name :: String.t(), opts :: keyword) ::
          {:ok, [OpenApiTypesense.CurationItemSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_curation_set_items(curation_set_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name],
      call: {OpenApiTypesense.CurationSets, :retrieve_curation_set_items},
      url: "/curation_sets/#{curation_set_name}/items",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.CurationItemSchema, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all curation sets

  Retrieve all curation sets
  """
  @doc since: "1.2.0"
  @spec retrieve_curation_sets(opts :: keyword) ::
          {:ok, [OpenApiTypesense.CurationSetSchema.t()]} | :error
  def retrieve_curation_sets(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.CurationSets, :retrieve_curation_sets},
      url: "/curation_sets",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.CurationSetSchema, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a curation set

  Create or update a curation set with the given name

  ## Request Body

  **Content Types**: `application/json`

  The curation set to be created/updated
  """
  @doc since: "1.2.0"
  @spec upsert_curation_set(
          curation_set_name :: String.t(),
          body :: OpenApiTypesense.CurationSetCreateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CurationSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_curation_set(curation_set_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name, body: body],
      call: {OpenApiTypesense.CurationSets, :upsert_curation_set},
      url: "/curation_sets/#{curation_set_name}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.CurationSetCreateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CurationSetSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create or update a curation set item

  Create or update a curation set item with the given id

  ## Request Body

  **Content Types**: `application/json`

  The curation item to be created/updated
  """
  @doc since: "1.2.0"
  @spec upsert_curation_set_item(
          curation_set_name :: String.t(),
          item_id :: String.t(),
          body :: OpenApiTypesense.CurationItemCreateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.CurationItemSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_curation_set_item(curation_set_name, item_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [curation_set_name: curation_set_name, item_id: item_id, body: body],
      call: {OpenApiTypesense.CurationSets, :upsert_curation_set_item},
      url: "/curation_sets/#{curation_set_name}/items/#{item_id}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.CurationItemCreateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.CurationItemSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
