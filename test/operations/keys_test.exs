defmodule KeysTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiKey
  alias OpenApiTypesense.ApiKeysResponse
  alias OpenApiTypesense.ApiKeyDeleteResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Keys

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

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

    %{api_key_schema: api_key_schema, conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: get a specific key", %{
    api_key_schema: api_key_schema,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, api_key} = Keys.create_key(api_key_schema)

    key_id = api_key.id

    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(key_id)
    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(key_id, [])
    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(conn, key_id)
    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(map_conn, key_id)
    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(conn, key_id, [])
    assert {:ok, %ApiKey{id: ^key_id}} = Keys.get_key(map_conn, key_id, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list API keys", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %ApiKeysResponse{keys: keys}} = Keys.get_keys()
    assert length(keys) >= 0

    assert {:ok, %ApiKeysResponse{}} = Keys.get_keys([])
    assert {:ok, %ApiKeysResponse{}} = Keys.get_keys(conn)
    assert {:ok, %ApiKeysResponse{}} = Keys.get_keys(map_conn)
    assert {:ok, %ApiKeysResponse{}} = Keys.get_keys(conn, [])
    assert {:ok, %ApiKeysResponse{}} = Keys.get_keys(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete an API key", %{
    api_key_schema: api_key_schema,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, api_key} = Keys.create_key(api_key_schema)

    key_id = api_key.id

    assert {:ok, %ApiKeyDeleteResponse{id: ^key_id}} = Keys.delete_key(key_id)
    assert {:error, _} = Keys.delete_key(key_id, [])
    assert {:error, _} = Keys.delete_key(conn, key_id)
    assert {:error, _} = Keys.delete_key(map_conn, key_id)
    assert {:error, _} = Keys.delete_key(conn, key_id, [])
    assert {:error, _} = Keys.delete_key(map_conn, key_id, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: create an search-only API key", %{
    api_key_schema: api_key_schema,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, %ApiKey{}} = Keys.create_key(api_key_schema)
    assert {:ok, %ApiKey{}} = Keys.create_key(api_key_schema, [])
    assert {:ok, %ApiKey{}} = Keys.create_key(conn, api_key_schema)
    assert {:ok, %ApiKey{}} = Keys.create_key(map_conn, api_key_schema)
    assert {:ok, %ApiKey{}} = Keys.create_key(conn, api_key_schema, [])
    assert {:ok, %ApiKey{}} = Keys.create_key(map_conn, api_key_schema, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: create an admin API key", %{api_key_schema: api_key_schema} do
    body =
      api_key_schema
      |> Map.put(:actions, ["*"])
      |> Map.put(:collections, ["*"])

    assert {:ok, %ApiKey{}} = Keys.create_key(body)
  end
end
