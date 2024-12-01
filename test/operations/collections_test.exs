defmodule CollectionsTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Collections

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionAliasesResponse
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.ApiResponse

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
