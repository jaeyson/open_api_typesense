defmodule OpenApiTypesense.NlSearchModels do
  @moduledoc since: "1.1.0"

  @moduledoc """
  Provides API endpoints related to nl search models
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Create a NL search model

  Create a new NL search model.

  ## Request Body

  **Content Types**: `application/json`

  The NL search model to be created
  """
  @doc since: "1.1.0"
  @spec create_nl_search_model(
          body :: OpenApiTypesense.NLSearchModelCreateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.NLSearchModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_nl_search_model(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.NlSearchModels, :create_nl_search_model},
      url: "/nl_search_models",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.NLSearchModelCreateSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.NLSearchModelSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a NL search model

  Delete a specific NL search model by its ID.
  """
  @doc since: "1.1.0"
  @spec delete_nl_search_model(model_id :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.NLSearchModelDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_nl_search_model(model_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [model_id: model_id],
      call: {OpenApiTypesense.NlSearchModels, :delete_nl_search_model},
      url: "/nl_search_models/#{model_id}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.NLSearchModelDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all NL search models

  Retrieve all NL search models.
  """
  @doc since: "1.1.0"
  @spec retrieve_all_nl_search_models(opts :: keyword) ::
          {:ok, [OpenApiTypesense.NLSearchModelSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_nl_search_models(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.NlSearchModels, :retrieve_all_nl_search_models},
      url: "/nl_search_models",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.NLSearchModelSchema, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a NL search model

  Retrieve a specific NL search model by its ID.
  """
  @doc since: "1.1.0"
  @spec retrieve_nl_search_model(model_id :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.NLSearchModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_nl_search_model(model_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [model_id: model_id],
      call: {OpenApiTypesense.NlSearchModels, :retrieve_nl_search_model},
      url: "/nl_search_models/#{model_id}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.NLSearchModelSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update a NL search model

  Update an existing NL search model.

  ## Request Body

  **Content Types**: `application/json`

  The NL search model fields to update
  """
  @doc since: "1.1.0"
  @spec update_nl_search_model(
          model_id :: String.t(),
          body :: OpenApiTypesense.NLSearchModelCreateSchema.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.NLSearchModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_nl_search_model(model_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [model_id: model_id, body: body],
      call: {OpenApiTypesense.NlSearchModels, :update_nl_search_model},
      url: "/nl_search_models/#{model_id}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.NLSearchModelCreateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.NLSearchModelSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
