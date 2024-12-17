defmodule KeysTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiKey
  alias OpenApiTypesense.ApiKeysResponse
  alias OpenApiTypesense.ApiKeyDeleteResponse
  alias OpenApiTypesense.Keys

  setup_all do
    api_key_schema = %{
      actions: ["documents:search"],
      collections: ["companies"],
      description: "Search-only companies key"
    }

    on_exit(fn ->
      {:ok, %ApiKeysResponse{keys: keys}} = Keys.get_keys()

      keys
      |> Enum.each(fn key ->
        {:ok, %ApiKeyDeleteResponse{}} = Keys.delete_key(key.id)
      end)
    end)

    %{api_key_schema: api_key_schema}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: get a specific key", %{api_key_schema: api_key_schema} do
    assert {:ok, api_key} = Keys.create_key(api_key_schema)

    key_id = api_key.id

    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(key_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list API keys" do
    {:ok, %ApiKeysResponse{keys: keys}} = Keys.get_keys()
    assert length(keys) >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete an API key", %{api_key_schema: api_key_schema} do
    assert {:ok, api_key} = Keys.create_key(api_key_schema)

    key_id = api_key.id

    assert {:ok, %ApiKeyDeleteResponse{id: ^key_id}} = Keys.delete_key(key_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: create an search-only API key", %{api_key_schema: api_key_schema} do
    assert {:ok, %ApiKey{}} = Keys.create_key(api_key_schema)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: create an admin API key", %{api_key_schema: api_key_schema} do
    body =
      api_key_schema
      |> Map.put(:actions, ["*"])
      |> Map.put(:collections, ["*"])

    assert {:ok, %ApiKey{}} = Keys.create_key(body)
  end
end
