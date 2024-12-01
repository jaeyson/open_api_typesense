defmodule CollectionsTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Collections

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionAliasesResponse
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Field
  alias OpenApiTypesense.CollectionSchema

  setup_all do
    # fields =
    #   [
    #     %{name: "company_name", type: "string"},
    #     %{name: "companies_id", type: "int32"},
    #     %{name: "country", type: "string", facet: true}
    #   ]
    #   |> Enum.map(&struct(Field, &1))

    # schema =
    #   struct(CollectionSchema, %{
    #     name: "companies",
    #     fields: fields,
    #     default_sorting_field: "companies_id"
    #   })
    schema = %{
      name: "companies",
      fields: [
        %{name: "company_name", type: "string"},
        %{name: "companies_id", type: "int32"},
        %{name: "country", type: "string", facet: true}
      ],
      default_sorting_field: "companies_id"
    }

    on_exit(fn ->
      Collections.delete_collection(schema.name)
    end)

    %{schema: schema}
  end

  test "wip: create collection", %{schema: schema} do
    assert Collections.create_collection(schema) == :ok
  end

  test "success: list empty collection" do
    assert {:ok, [%CollectionResponse{}]} = Collections.get_collections()
  end

  test "success: list empty aliases" do
    assert {:ok, %CollectionAliasesResponse{aliases: []}} = Collections.get_aliases()
  end

  test "success: delete missing collection" do
    assert Collections.delete_collection("non-existing-collection") ==
             {:error,
              %OpenApiTypesense.ApiResponse{
                message: "No collection with name `non-existing-collection` found."
              }}
  end

  test "error: non-existing alias" do
    assert Collections.get_alias("non-existing-alias") ==
             {:error, %ApiResponse{message: "Not Found"}}
  end

  test "error: non-existing collection" do
    assert Collections.get_collection("non-existing-collection") ==
             {:error, %ApiResponse{message: "Not Found"}}
  end
end
