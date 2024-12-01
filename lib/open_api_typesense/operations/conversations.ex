defmodule OpenApiTypesense.Conversations do
  @moduledoc """
  Provides API endpoints related to conversations
  """

  @default_client OpenApiTypesense.Client

  @doc """
  post `/conversations/models`

  Create a Conversation Model
  """
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
        {400, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete a conversation model

  Delete a conversation model
  """
  @spec delete_conversation_model(String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def delete_conversation_model(modelId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :delete_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :delete,
      response: [{200, {OpenApiTypesense.ConversationModelSchema, :t}}],
      opts: opts
    })
  end

  @doc """
  List all conversation models

  Retrieve all conversation models
  """
  @spec retrieve_all_conversation_models(keyword) ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]} | :error
  def retrieve_all_conversation_models(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Conversations, :retrieve_all_conversation_models},
      url: "/conversations/models",
      method: :get,
      response: [{200, [{OpenApiTypesense.ConversationModelSchema, :t}]}],
      opts: opts
    })
  end

  @doc """
  Retrieve a conversation model

  Retrieve a conversation model
  """
  @spec retrieve_conversation_model(String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def retrieve_conversation_model(modelId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :retrieve_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :get,
      response: [{200, {OpenApiTypesense.ConversationModelSchema, :t}}],
      opts: opts
    })
  end

  @doc """
  Update a conversation model

  Update a conversation model
  """
  @spec update_conversation_model(
          String.t(),
          OpenApiTypesense.ConversationModelUpdateSchema.t(),
          keyword
        ) :: {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def update_conversation_model(modelId, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [modelId: modelId, body: body],
      call: {OpenApiTypesense.Conversations, :update_conversation_model},
      url: "/conversations/models/#{modelId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.ConversationModelUpdateSchema, :t}}],
      response: [{200, {OpenApiTypesense.ConversationModelSchema, :t}}],
      opts: opts
    })
  end
end
