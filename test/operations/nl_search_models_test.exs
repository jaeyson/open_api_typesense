defmodule NlSearchModelsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.NlSearchModels

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    model = %{
      "id" => "gemini-model",
      "model_name" => "google/gemini-2.5-flash",
      "api_key" => "YOUR_GOOGLE_AI_STUDIO_API_KEY",
      "max_bytes" => 16_000,
      "temperature" => 0.0
    }

    %{conn: conn, map_conn: map_conn, model: model}
  end

  @tag [nls: true]
  test "error: create natural language search model", %{
    conn: conn,
    map_conn: map_conn,
    model: model
  } do
    reason = %ApiResponse{
      message: "Google Gemini API error: API key not valid. Please pass a valid API key."
    }

    assert {:error, ^reason} = NlSearchModels.create_nl_search_model(model)
    assert {:error, ^reason} = NlSearchModels.create_nl_search_model(model, [])
    assert {:error, ^reason} = NlSearchModels.create_nl_search_model(model, conn: conn)
    assert {:error, ^reason} = NlSearchModels.create_nl_search_model(model, map_conn: map_conn)
  end

  @tag [nls: true]
  test "error: delete natural language search model", %{
    conn: conn,
    map_conn: map_conn,
    model: model
  } do
    reason = %ApiResponse{message: "Model not found"}

    assert {:error, ^reason} = NlSearchModels.delete_nl_search_model(model["id"])
    assert {:error, ^reason} = NlSearchModels.delete_nl_search_model(model["id"], [])
    assert {:error, ^reason} = NlSearchModels.delete_nl_search_model(model["id"], conn: conn)

    assert {:error, ^reason} =
             NlSearchModels.delete_nl_search_model(model["id"], map_conn: map_conn)
  end

  @tag [nls: true]
  test "success: retrieve all natural language search models", %{conn: conn, map_conn: map_conn} do
    assert {:ok, []} = NlSearchModels.retrieve_all_nl_search_models()
    assert {:ok, []} = NlSearchModels.retrieve_all_nl_search_models([])
    assert {:ok, []} = NlSearchModels.retrieve_all_nl_search_models(conn: conn)
    assert {:ok, []} = NlSearchModels.retrieve_all_nl_search_models(map_conn: map_conn)
  end

  @tag [nls: true]
  test "success: retrieve a natural language search model", %{
    conn: conn,
    map_conn: map_conn,
    model: model
  } do
    reason = %ApiResponse{message: "Model not found"}

    assert {:error, ^reason} = NlSearchModels.retrieve_nl_search_model(model["id"])
    assert {:error, ^reason} = NlSearchModels.retrieve_nl_search_model(model["id"], [])
    assert {:error, ^reason} = NlSearchModels.retrieve_nl_search_model(model["id"], conn: conn)

    assert {:error, ^reason} =
             NlSearchModels.retrieve_nl_search_model(model["id"], map_conn: map_conn)
  end

  @tag [nls: true]
  test "error: update a natural language search model", %{
    conn: conn,
    map_conn: map_conn,
    model: model
  } do
    body = %{
      "temperature" => 0.2,
      "system_prompt" => "New system prompt instructions"
    }

    reason = %ApiResponse{message: "Model not found"}

    assert {:error, ^reason} = NlSearchModels.update_nl_search_model(model["id"], body)
    assert {:error, ^reason} = NlSearchModels.update_nl_search_model(model["id"], body, [])

    assert {:error, ^reason} =
             NlSearchModels.update_nl_search_model(model["id"], body, conn: conn)

    assert {:error, ^reason} =
             NlSearchModels.update_nl_search_model(model["id"], body, map_conn: map_conn)
  end
end
