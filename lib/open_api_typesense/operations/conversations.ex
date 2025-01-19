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
  @spec create_conversation_model(map()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(body) do
    create_conversation_model(Connection.new(), body)
  end

  @doc """
  Either one of:
  - `create_conversation_model(body, opts)`
  - `create_conversation_model(%{api_key: xyz, host: ...}, body)`
  - `create_conversation_model(Connection.new(), body)`
  """
  @spec create_conversation_model(map() | Connection.t(), map() | keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(body, opts) when is_list(opts) do
    create_conversation_model(Connection.new(), body, opts)
  end

  def create_conversation_model(conn, body) do
    create_conversation_model(conn, body, [])
  end

  @doc """
  Either one of:
  - `create_conversation_model(%{api_key: xyz, host: ...}, body, opts)`
  - `create_conversation_model(Connection.new(), body, opts)`
  """
  @spec create_conversation_model(map() | Connection.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_conversation_model(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    create_conversation_model(Connection.new(conn), body, opts)
  end

  def create_conversation_model(%Connection{} = conn, body, opts) when is_struct(conn) do
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
  @spec delete_conversation_model(String.t()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_conversation_model(modelId) do
    delete_conversation_model(Connection.new(), modelId)
  end

  @doc """
  Either one of:
  - `delete_conversation_model(modelId, opts)`
  - `delete_conversation_model(%{api_key: xyz, host: ...}, modelId)`
  - `delete_conversation_model(Connection.new(), modelId)`
  """
  @spec delete_conversation_model(map() | Connection.t(), String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_conversation_model(modelId, opts) when is_list(opts) and is_binary(modelId) do
    delete_conversation_model(Connection.new(), modelId, opts)
  end

  def delete_conversation_model(conn, modelId) do
    delete_conversation_model(conn, modelId, [])
  end

  @doc """
  Either one of:
  - `delete_conversation_model(%{api_key: xyz, host: ...}, modelId, opts)`
  - `delete_conversation_model(Connection.new(), modelId, opts)`
  """
  @spec delete_conversation_model(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_conversation_model(conn, modelId, opts) when not is_struct(conn) and is_map(conn) do
    delete_conversation_model(Connection.new(conn), modelId, opts)
  end

  def delete_conversation_model(%Connection{} = conn, modelId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec retrieve_all_conversation_models ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_conversation_models do
    retrieve_all_conversation_models(Connection.new())
  end

  @doc """
  Either one of:
  - `retrieve_all_conversation_models(opts)`
  - `retrieve_all_conversation_models(%{api_key: xyz, host: ...})`
  - `retrieve_all_conversation_models(Connection.new())`
  """
  @spec retrieve_all_conversation_models(map() | Connection.t() | keyword()) ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_conversation_models(opts) when is_list(opts) do
    retrieve_all_conversation_models(Connection.new(), opts)
  end

  def retrieve_all_conversation_models(conn) do
    retrieve_all_conversation_models(conn, [])
  end

  @doc """
  Either one of:
  - `retrieve_all_conversation_models(%{api_key: xyz, host: ...}, opts)`
  - `retrieve_all_conversation_models(Connection.new(), opts)`
  """
  @spec retrieve_all_conversation_models(map() | Connection.t(), keyword()) ::
          {:ok, [OpenApiTypesense.ConversationModelSchema.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_conversation_models(conn, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_all_conversation_models(Connection.new(conn), opts)
  end

  def retrieve_all_conversation_models(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec retrieve_conversation_model(String.t()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_conversation_model(modelId) do
    retrieve_conversation_model(Connection.new(), modelId)
  end

  @doc """
  Either one of:
  - `retrieve_conversation_model(modelId, opts)`
  - `retrieve_conversation_model(%{api_key: xyz, host: ...}, modelId)`
  - `retrieve_conversation_model(Connection.new(), modelId)`
  """
  @spec retrieve_conversation_model(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_conversation_model(modelId, opts) when is_list(opts) and is_binary(modelId) do
    retrieve_conversation_model(Connection.new(), modelId, opts)
  end

  def retrieve_conversation_model(conn, modelId) do
    retrieve_conversation_model(conn, modelId, [])
  end

  @doc """
  Either one of:
  - `retrieve_conversation_model(%{api_key: xyz, host: ...}, modelId, opts)`
  - `retrieve_conversation_model(Connection.new(), modelId, opts)`
  """
  @spec retrieve_conversation_model(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_conversation_model(conn, modelId, opts)
      when not is_struct(conn) and is_map(conn) do
    retrieve_conversation_model(Connection.new(conn), modelId, opts)
  end

  def retrieve_conversation_model(%Connection{} = conn, modelId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec update_conversation_model(String.t(), map()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_conversation_model(modelId, body) do
    update_conversation_model(Connection.new(), modelId, body)
  end

  @doc """
  Either one of:
  - `update_conversation_model(modelId, body, opts)`
  - `update_conversation_model(%{api_key: xyz, host: ...}, modelId, body)`
  - `update_conversation_model(Connection.new(), modelId, body)`
  """
  @spec update_conversation_model(
          map() | Connection.t() | String.t(),
          String.t() | map(),
          map() | keyword()
        ) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_conversation_model(modelId, body, opts) when is_list(opts) and is_binary(modelId) do
    update_conversation_model(Connection.new(), modelId, body, opts)
  end

  def update_conversation_model(conn, modelId, body) do
    update_conversation_model(conn, modelId, body, [])
  end

  @doc """
  Either one of:
  - `update_conversation_model(%{api_key: xyz, host: ...}, modelId, body, opts)`
  - `update_conversation_model(Connection.new(), modelId, body, opts)`
  """
  @spec update_conversation_model(map() | Connection.t(), String.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.ConversationModelSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def update_conversation_model(conn, modelId, body, opts)
      when not is_struct(conn) and is_map(conn) do
    update_conversation_model(Connection.new(conn), modelId, body, opts)
  end

  def update_conversation_model(%Connection{} = conn, modelId, body, opts) when is_struct(conn) do
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
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
