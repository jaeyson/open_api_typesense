defmodule DocumentsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Documents
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.SearchOverride
  alias OpenApiTypesense.SearchOverridesResponse

  setup_all do
    name = "shoes"

    schema =
      %{
        name: name,
        fields: [
          %{name: "shoe_type", type: "string"},
          %{name: "#{name}_id", type: "int32"},
          %{name: "description", type: "string"},
          %{name: "price", type: "string"}
        ],
        default_sorting_field: "#{name}_id"
      }
      |> Jason.encode!()

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, collections} = Collections.get_collections()
      Enum.map(collections, &Collections.delete_collection(&1.name))
    end)

    %{coll_name: name}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: import documents", %{coll_name: coll_name} do
    body =
      [
        %{
          "shoes_id" => 123,
          "shoe_type" => "sneaker",
          "description" => """
          UGG Men's South Bay Low Sneaker
          - Full-grain leather upper
          - Suede overlays
          - Treadlite by UGG outsole for comfort
          - Textile lining
          - Cotton laces
          """,
          "price" => "usd 99.95"
        },
        %{
          "shoes_id" => 483,
          "shoe_type" => "boot",
          "description" => """
          UGG Men's Neumel Boot
          - 17mm UGGpure wool insole
          - Outsole is low profile eva for comfort
          - 17mm UGGpure wool lining
          - Wear indoors as a slipper or out with slim jeans and a V-neck
          - Treadlite by UGG outsole for comfort
          """,
          "price" => "usd 139.95"
        }
      ]
      |> Enum.map_join("\n", &Jason.encode!/1)

    assert {:ok, _} = Documents.import_documents(coll_name, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: index a document", %{coll_name: coll_name} do
    shoes_id = 220

    body =
      %{
        shoes_id: shoes_id,
        shoe_type: "slipper",
        description: """
        UGG Men's Tasman Slipper
        - Suede upper
        - 17mm UGGplush wool lining
        - 17mm UGGplush wool insole
        - Sugarcane EVA outsole
        """,
        price: "usd 109.95"
      }
      |> Jason.encode!()

    assert {:ok, %{shoes_id: ^shoes_id}} = Documents.index_document(coll_name, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collection overrides", %{coll_name: coll_name} do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Documents.get_search_overrides("wrong_collection")

    {:ok, %SearchOverridesResponse{overrides: overrides}} =
      Documents.get_search_overrides(coll_name)

    assert overrides >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: get a non-existent override", %{coll_name: coll_name} do
    assert {:error, %ApiResponse{message: "override non-existent not found."}} =
             Documents.get_search_override(coll_name, "non-existent")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: delete a non-existent override", %{coll_name: coll_name} do
    assert {:error, %ApiResponse{message: "Could not find that `id`."}} =
             Documents.delete_search_override(coll_name, "non-existent")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete a document", %{coll_name: coll_name} do
    shoes_id = 420

    body =
      %{
        shoes_id: shoes_id,
        shoe_type: "slipper",
        description: """
        - UGG Men's Ascot Slipper
        - Cast in a classic loafer silhouette. Water-resistant suede.
        - Rubber outsole
        - UGGpure wool lining and insole
        - Suede upper
        - Available in whole sizes only. If between sizes, please order 1/2 size up from your usual size.
        """,
        price: "usd 109.95"
      }
      |> Jason.encode!()

    {:ok, %{id: id}} = Documents.index_document(coll_name, body)
    assert {:ok, %{id: ^id}} = Documents.delete_document(coll_name, id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete all documents", %{coll_name: coll_name} do
    body =
      [
        %{
          "shoes_id" => 111,
          "shoe_type" => "sneaker",
          "description" => """
          UGG Men's South Bay Low Sneaker
          - Full-grain leather upper
          - Suede overlays
          - Treadlite by UGG outsole for comfort
          - Textile lining
          - Cotton laces
          """,
          "price" => "usd 99.95"
        },
        %{
          "shoes_id" => 444,
          "shoe_type" => "boot",
          "description" => """
          UGG Men's Neumel Boot
          - 17mm UGGpure wool insole
          - Outsole is low profile eva for comfort
          - 17mm UGGpure wool lining
          - Wear indoors as a slipper or out with slim jeans and a V-neck
          - Treadlite by UGG outsole for comfort
          """,
          "price" => "usd 139.95"
        }
      ]
      |> Enum.map_join("\n", &Jason.encode!/1)

    assert {:ok, _} = Documents.import_documents(coll_name, body)

    assert {:ok, %Documents{num_deleted: _, num_updated: nil}} =
             Documents.delete_documents(coll_name, filter_by: "shoes_id:>=0")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: delete all documents without filter_by params", %{coll_name: coll_name} do
    message = "Parameter `filter_by` must be provided."
    assert {:error, %ApiResponse{message: ^message}} = Documents.delete_documents(coll_name)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: delete a non-existent document", %{coll_name: coll_name} do
    document_id = 9999
    message = "Could not find a document with id: #{document_id}"

    assert {:error, %ApiResponse{message: ^message}} =
             Documents.delete_document(coll_name, document_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: get a non-existent document", %{coll_name: coll_name} do
    document_id = 9999
    message = "Could not find a document with id: #{document_id}"

    assert {:error, %ApiResponse{message: ^message}} =
             Documents.get_document(coll_name, document_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: export document from a non-existent collection" do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Documents.export_documents("non-existent-collection")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert a search override", %{coll_name: coll_name} do
    body =
      %{
        "rule" => %{
          "query" => "apple",
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
      |> Jason.encode!()

    assert {:ok, %SearchOverride{}} =
             Documents.upsert_search_override(coll_name, "customize-apple", body)
  end
end
