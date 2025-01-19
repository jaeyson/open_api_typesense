defmodule CurationTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Curation
  alias OpenApiTypesense.SearchOverride
  alias OpenApiTypesense.SearchOverridesResponse

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    name = "brands"

    schema =
      %{
        name: name,
        fields: [
          %{name: "brand_name", type: "string"},
          %{name: "#{name}_id", type: "int32"}
        ],
        default_sorting_field: "#{name}_id"
      }

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^name}} = Collections.delete_collection(name)
    end)

    %{schema_name: name, conn: conn, map_conn: map_conn}
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: upsert search override", %{
    schema_name: schema_name,
    conn: conn,
    map_conn: map_conn
  } do
    override_id = "customize-loca-cola"

    body =
      %{
        "rule" => %{
          "query" => "Loca Cola",
          "match" => "exact"
        },
        "includes" => [
          %{"id" => "422", "position" => 1},
          %{"id" => "54", "position" => 2}
        ],
        "excludes" => [
          %{"id" => "287"}
        ]
      }

    assert {:ok, %SearchOverride{id: ^override_id}} =
             Curation.upsert_search_override(schema_name, override_id, body)

    assert {:ok, _} = Curation.upsert_search_override(schema_name, override_id, body, [])
    assert {:ok, _} = Curation.upsert_search_override(conn, schema_name, override_id, body)
    assert {:ok, _} = Curation.upsert_search_override(map_conn, schema_name, override_id, body)
    assert {:ok, _} = Curation.upsert_search_override(conn, schema_name, override_id, body, [])

    assert {:ok, _} =
             Curation.upsert_search_override(map_conn, schema_name, override_id, body, [])
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: delete search override", %{
    schema_name: schema_name,
    conn: conn,
    map_conn: map_conn
  } do
    message = "Could not find that `id`."

    assert {:error, %ApiResponse{message: ^message}} =
             Curation.delete_search_override(schema_name, "test")

    assert {:error, _} = Curation.delete_search_override(schema_name, "test", [])
    assert {:error, _} = Curation.delete_search_override(conn, schema_name, "test")
    assert {:error, _} = Curation.delete_search_override(map_conn, schema_name, "test")
    assert {:error, _} = Curation.delete_search_override(conn, schema_name, "test", [])
    assert {:error, _} = Curation.delete_search_override(map_conn, schema_name, "test", [])
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: list collection overrides", %{
    schema_name: schema_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, %SearchOverridesResponse{overrides: overrides}} =
             Curation.get_search_overrides(schema_name)

    assert length(overrides) >= 0
    assert {:ok, _} = Curation.get_search_overrides(schema_name, [])
    assert {:ok, _} = Curation.get_search_overrides(conn, schema_name)
    assert {:ok, _} = Curation.get_search_overrides(map_conn, schema_name)
    assert {:ok, _} = Curation.get_search_overrides(conn, schema_name, [])
    assert {:ok, _} = Curation.get_search_overrides(map_conn, schema_name, [])
  end
end
