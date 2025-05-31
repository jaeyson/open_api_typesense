defmodule OpenApiTypesense.Conversations do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to conversations
  """

  @default_client OpenApiTypesense.Client

  @doc """
  post `/conversations/models`

  Create a Conversation Model
  """
  @doc since: "0.4.0"
  @spec create_conversation_model(OpenApiTypesense.ConversationModelCreateSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Conversations, :create_conversation_model},
      url: "/conversations/models",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.ConversationModelCreateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a conversation model

  Delete a conversation model
  """
  @doc since: "0.4.0"
  @spec delete_conversation_model(String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_conversation_model(modelId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :delete_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List all conversation models

  Retrieve all conversation models
  """
  @doc since: "0.4.0"
  @spec retrieve_all_conversation_models(keyword) ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_conversation_models(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Conversations, :retrieve_all_conversation_models},
      url: "/conversations/models",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.ConversationModelSchema, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve a conversation model

  Retrieve a conversation model
  """
  @doc since: "0.4.0"
  @spec retrieve_conversation_model(String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_conversation_model(modelId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :retrieve_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update a conversation model

  Update a conversation model
  """
  @doc since: "0.4.0"
  @spec update_conversation_model(
          String.t(),
          OpenApiTypesense.ConversationModelUpdateSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_conversation_model(modelId, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId, body: body],
      call: {OpenApiTypesense.Conversations, :update_conversation_model},
      url: "/conversations/models/#{modelId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.ConversationModelUpdateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
