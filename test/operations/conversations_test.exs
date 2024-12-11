defmodule ConversationsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Conversations

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
end
