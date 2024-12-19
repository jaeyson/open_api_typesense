defmodule ConversationsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Conversations

  setup_all do
    name = "conversation_store"

    schema =
      %{
        "name" => name,
        "fields" => [
          %{"name" => "conversation_id", "type" => "string"},
          %{"name" => "model_id", "type" => "string"},
          %{"name" => "timestamp", "type" => "int32"},
          %{"name" => "role", "type" => "string", "index" => false},
          %{"name" => "message", "type" => "string", "index" => false}
        ]
      }

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^name}} = Collections.delete_collection(name)
    end)

    :ok
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: list conversation models" do
    assert {:ok, []} = Conversations.retrieve_all_conversation_models()
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "error: get a non-existent conversation model" do
    assert {:error, %ApiResponse{message: "Model not found"}} =
             Conversations.retrieve_conversation_model("non-existent")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: delete a conversation model" do
    assert {:error, %ApiResponse{message: "Model not found"}} =
             Conversations.delete_conversation_model("non-existent")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "error: create a conversation model with incorrect API key" do
    body =
      %{
        "id" => "conv-model-1",
        "model_name" => "openai/gpt-3.5-turbo",
        "history_collection" => "conversation_store",
        "api_key" => "OPENAI_API_KEY",
        "system_prompt" =>
          "You are an assistant for question-answering. You can only make conversations based on the provided context. If a response cannot be formed strictly using the provided context, politely say you do not have knowledge about that topic.",
        "max_bytes" => 16_384
      }

    assert {:error, %ApiResponse{message: message}} =
             Conversations.create_conversation_model(body)

    assert String.contains?(String.downcase(message), [
             "error",
             "incorrect",
             "parsing",
             "response"
           ]) === true
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "error: update a conversation model with incorrect API key" do
    model_id = "conv-model-1"

    body =
      %{
        "id" => model_id,
        "model_name" => "openai/gpt-3.5-turbo",
        "history_collection" => "conversation_store",
        "api_key" => "OPENAI_API_KEY",
        "system_prompt" =>
          "Hey, you are an **intelligent** assistant for question-answering. You can only make conversations based on the provided context. If a response cannot be formed strictly using the provided context, politely say you do not have knowledge about that topic.",
        "max_bytes" => 16_384
      }

    assert {:error, %ApiResponse{message: _}} =
             Conversations.update_conversation_model(model_id, body)
  end
end
