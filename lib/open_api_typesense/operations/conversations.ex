defmodule OpenApiTypesense.Conversations do
  @moduledoc """
  Provides API endpoints related to conversations
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  post `/conversations/models`

  Create a Conversation Model
  """
  @spec create_conversation_model(OpenApiTypesense.ConversationModelCreateSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(body, opts \\ []) do
    create_conversation_model(Connection.new(), body, opts)
  end

  @spec create_conversation_model(
          Connection.t(),
          OpenApiTypesense.ConversationModelCreateSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(conn, body, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
    delete_conversation_model(Connection.new(), modelId, opts)
  end

  @spec delete_conversation_model(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def delete_conversation_model(conn, modelId, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :delete_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
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
    retrieve_all_conversation_models(Connection.new(), opts)
  end

  @spec retrieve_all_conversation_models(Connection.t(), keyword) ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]} | :error
  def retrieve_all_conversation_models(conn, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
    retrieve_conversation_model(Connection.new(), modelId, opts)
  end

  @spec retrieve_conversation_model(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def retrieve_conversation_model(conn, modelId, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [modelId: modelId],
      call: {OpenApiTypesense.Conversations, :retrieve_conversation_model},
      url: "/conversations/models/#{modelId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
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
    update_conversation_model(Connection.new(), modelId, body, opts)
  end

  @spec update_conversation_model(
          Connection.t(),
          String.t(),
          OpenApiTypesense.ConversationModelUpdateSchema.t(),
          keyword
        ) :: {:ok, OpenApiTypesense.ConversationModelSchema.t()} | :error
  def update_conversation_model(conn, modelId, body, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [modelId: modelId, body: body],
      call: {OpenApiTypesense.Conversations, :update_conversation_model},
      url: "/conversations/models/#{modelId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.ConversationModelUpdateSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.ConversationModelSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
