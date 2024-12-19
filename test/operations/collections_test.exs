defmodule CollectionsTest do
  use ExUnit.Case, async: true

  doctest OpenApiTypesense.Collections

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.CollectionAlias
  alias OpenApiTypesense.CollectionAliasesResponse
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionUpdateSchema

  setup_all do
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

    %{schema: schema, alias_name: "foo_bar"}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: create a collection", %{schema: schema} do
    name = schema["name"]

    assert {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collections" do
    {:ok, collections} = Collections.get_collections()
    assert length(collections) >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: update an existing collection" do
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

    assert {:ok, %CollectionUpdateSchema{}} =
             Collections.update_collection(name, body)

    Collections.delete_collection(name)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list empty aliases", %{alias_name: alias_name} do
    Collections.delete_alias(alias_name)
    assert {:ok, %CollectionAliasesResponse{aliases: []}} = Collections.get_aliases()
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete a missing collection" do
    assert Collections.delete_collection("non-existing-collection") ==
             {:error,
              %ApiResponse{
                message: "No collection with name `non-existing-collection` found."
              }}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert an alias", %{schema: schema, alias_name: alias_name} do
    collection_name = schema["name"]

    body = %{"collection_name" => collection_name}

    assert {:ok, %CollectionAlias{collection_name: ^collection_name, name: ^alias_name}} =
             Collections.upsert_alias(alias_name, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: get a non-existing alias" do
    assert Collections.get_alias("non-existing-alias") ==
             {:error, %ApiResponse{message: "Not Found"}}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: get a non-existing collection" do
    assert Collections.get_collection("non-existing-collection") ==
             {:error, %ApiResponse{message: "Not Found"}}
  end
end
