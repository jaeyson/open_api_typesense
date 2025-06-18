defmodule CollectionsTest do
  use ExUnit.Case, async: true

  doctest OpenApiTypesense.Collections

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.CollectionAlias
  alias OpenApiTypesense.CollectionAliasesResponse
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionUpdateSchema
  alias OpenApiTypesense.Connection

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    schema = %{
      "name" => "companies",
      "fields" => [
        %{"name" => "company_name", "type" => "string"},
        %{"name" => "companies_id", "type" => "int32"},
        %{"name" => "country", "type" => "string", "facet" => true}
      ],
      "default_sorting_field" => "companies_id"
    }

    on_exit(fn ->
      Collections.delete_collection(schema["name"])
    end)

    %{schema: schema, alias_name: "foo_bar", conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: clone a collection schema" do
    schema = %{
      "name" => "vehicles",
      "fields" => [
        %{"name" => "vehicle_type", "type" => "string"},
        %{"name" => "vehicles_id", "type" => "int32"},
        %{"name" => "description", "type" => "string"}
      ],
      "default_sorting_field" => "vehicles_id"
    }

    assert {:ok, %CollectionResponse{}} = Collections.create_collection(schema)

    payload = %{"name" => "vehicles_collection"}

    assert {:ok, %CollectionResponse{}} =
             Collections.create_collection(payload, src_name: schema["name"])

    assert {:ok, _} = Collections.delete_collection(schema["name"])

    assert {:ok, _} = Collections.delete_collection(payload["name"])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: create a collection", %{schema: schema, conn: conn, map_conn: map_conn} do
    name = schema["name"]

    assert {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)
    assert {:error, %ApiResponse{message: _}} = Collections.create_collection(schema, [])
    assert {:error, %ApiResponse{message: _}} = Collections.create_collection(schema, conn: conn)

    assert {:error, %ApiResponse{message: _}} =
             Collections.create_collection(schema, conn: map_conn)

    assert {:ok,
            [%OpenApiTypesense.CollectionResponse{fields: [%OpenApiTypesense.Field{} | _]} | _]} =
             Collections.get_collections()
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list collections", %{conn: conn, map_conn: map_conn} do
    assert {:ok, collections} = Collections.get_collections()
    assert length(collections) >= 0

    opts = [exclude_fields: "fields", limit: 1]
    assert {:ok, _} = Collections.get_collections(opts)
    assert {:ok, _} = Collections.get_collections(conn: conn)
    assert {:ok, _} = Collections.get_collections(conn: map_conn)
    assert {:ok, _} = Collections.get_collections(List.flatten([conn: conn], opts))
    assert {:ok, _} = Collections.get_collections(conn: map_conn, limit: 1)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: update an existing collection", %{conn: conn, map_conn: map_conn} do
    name = "burgers"

    schema =
      %{
        "name" => name,
        "fields" => [
          %{"name" => "burger_name", "type" => "string"},
          %{"name" => name <> "_id", "type" => "int32"},
          %{"name" => "price", "type" => "string"}
        ],
        "default_sorting_field" => name <> "_id"
      }

    assert {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    body = %{fields: [%{name: "price", drop: true}]}

    assert {:ok, %CollectionUpdateSchema{fields: [%{name: "price", drop: true}]}} =
             Collections.update_collection(name, body)

    assert {:error, %ApiResponse{message: _}} = Collections.update_collection(name, body, [])

    assert {:error, %ApiResponse{message: _}} =
             Collections.update_collection(name, body, conn: conn)

    assert {:error, %ApiResponse{message: _}} =
             Collections.update_collection(name, body, conn: map_conn)

    Collections.delete_collection(name)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list empty aliases", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %CollectionAliasesResponse{aliases: aliases}} = Collections.get_aliases()
    assert length(aliases) >= 0
    assert {:ok, _} = Collections.get_aliases([])
    assert {:ok, _} = Collections.get_aliases(conn: conn)
    assert {:ok, _} = Collections.get_aliases(conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete a missing collection", %{conn: conn, map_conn: map_conn} do
    assert Collections.delete_collection("non-existing-collection") ==
             {:error,
              %ApiResponse{
                message: "No collection with name `non-existing-collection` found."
              }}

    assert {:error, %ApiResponse{message: _}} = Collections.delete_collection("xyz", [])
    assert {:error, %ApiResponse{message: _}} = Collections.delete_collection("xyz", conn: conn)

    assert {:error, %ApiResponse{message: _}} =
             Collections.delete_collection("xyz", conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: upsert an alias", %{
    schema: schema,
    alias_name: alias_name,
    conn: conn,
    map_conn: map_conn
  } do
    collection_name = schema["name"]

    body = %{"collection_name" => collection_name}

    assert {:ok, %CollectionAlias{collection_name: ^collection_name, name: ^alias_name}} =
             Collections.upsert_alias(alias_name, body)

    assert {:ok, %CollectionAlias{}} = Collections.upsert_alias(alias_name, body, [])
    assert {:ok, %CollectionAlias{}} = Collections.upsert_alias(alias_name, body, conn: conn)
    assert {:ok, %CollectionAlias{}} = Collections.upsert_alias(alias_name, body, conn: map_conn)

    assert {:ok, %CollectionAlias{name: ^alias_name}} = Collections.delete_alias(alias_name)
    assert {:error, %ApiResponse{message: _}} = Collections.delete_alias(alias_name, [])
    assert {:error, %ApiResponse{message: _}} = Collections.delete_alias(alias_name, conn: conn)

    assert {:error, %ApiResponse{message: _}} =
             Collections.delete_alias(alias_name, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: get a non-existing alias", %{conn: conn, map_conn: map_conn} do
    assert Collections.get_alias("non-existing-alias") ==
             {:error, %ApiResponse{message: "Not Found"}}

    assert {:error, %ApiResponse{message: _}} = Collections.get_alias("xyz", [])
    assert {:error, %ApiResponse{message: _}} = Collections.get_alias("xyz", conn: conn)
    assert {:error, %ApiResponse{message: _}} = Collections.get_alias("xyz", conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: get a non-existing collection", %{conn: conn, map_conn: map_conn} do
    assert Collections.get_collection("non-existing-collection") ==
             {:error, %ApiResponse{message: "Not Found"}}

    assert {:error, %ApiResponse{message: _}} = Collections.get_collection("xyz")
    assert {:error, %ApiResponse{message: _}} = Collections.get_collection("xyz", [])
    assert {:error, %ApiResponse{message: _}} = Collections.get_collection("xyz", conn: conn)
    assert {:error, %ApiResponse{message: _}} = Collections.get_collection("xyz", conn: map_conn)
  end
end
