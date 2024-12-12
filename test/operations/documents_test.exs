defmodule DocumentsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Documents
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.MultiSearchResult
  alias OpenApiTypesense.SearchOverride
  alias OpenApiTypesense.SearchOverridesResponse
  alias OpenApiTypesense.SearchResult

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
      |> Jason.encode_to_iodata!()

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^name}} = Collections.delete_collection(name)
    end)

    %{coll_name: name}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: update a non-existent document", %{coll_name: coll_name} do
    body =
      %{
        "shoe_type" => "athletic shoes"
      }
      |> Jason.encode_to_iodata!()

    document_id = 9999
    message = "Could not find a document with id: #{document_id}"

    assert {:error, %ApiResponse{message: ^message}} =
             Documents.update_document(coll_name, document_id, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: search a document", %{coll_name: coll_name} do
    body =
      [
        %{
          "shoes_id" => 333,
          "shoe_type" => "slipper",
          "description" => """
          UGG Men's Scuff Slipper
          - Full-grain leather upper
          - 17mm sheepskin insole
          - Foam footbed
          - Suede outsole
          - Recycled polyester binding
          """,
          "price" => "usd 89.95"
        },
        %{
          "shoes_id" => 888,
          "shoe_type" => "boot",
          "description" => """
          UGG Men's Classic Ultra Mini Boot
          - 17mm Twinface sheepskin upper
          - 17mm UGGplush upcycled wool insole
          - Treadlite by UGG outsole
          - Foam footbed
          """,
          "price" => "usd 149.95"
        }
      ]
      |> Enum.map_join("\n", &Jason.encode_to_iodata!/1)

    assert {:ok, _} = Documents.import_documents(coll_name, body)

    assert {:ok, %SearchResult{hits: hits}} =
             Documents.search_collection(coll_name,
               q: "sheepskin",
               query_by: "description",
               enable_analytics: false
             )

    assert length(hits) === 2
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: update non-existent documents", %{coll_name: coll_name} do
    body =
      [
        %{"id" => "9981", "price" => "usd 1.00"},
        %{"id" => "9982", "price" => "usd 1.00"}
      ]
      |> Enum.map_join("\n", &Jason.encode_to_iodata!/1)

    assert {:ok, [%{"success" => false}, %{"success" => false}]} =
             Documents.import_documents(coll_name, body, action: "update")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: multi-search with no documents" do
    body =
      %{
        "searches" => [
          %{collection: "shoes", q: "Nike"},
          %{collection: "shoes", q: "Adidas"}
        ]
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %MultiSearchResult{results: results}} =
             Documents.multi_search(body, query_by: "description", enable_analytics: false)

    [result_one, result_two] = results
    assert result_one.found === 0
    assert result_two.found === 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: update documents by query", %{coll_name: coll_name} do
    body =
      [
        %{
          "shoes_id" => 55,
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
          "shoes_id" => 66,
          "shoe_type" => "slipper",
          "description" => """
          UGG Men's Leather Ascot Slipper
          - Cast in a classic loafer silhouette. Water-resistant suede.
          - Rubber outsole
          - UGGpure wool lining and insole
          - Suede upper
          - Available in whole sizes only. If between sizes, please order 1/2 size up from your usual size.
          """,
          "price" => "usd 139.95"
        }
      ]
      |> Enum.map_join("\n", &Jason.encode_to_iodata!/1)

    assert {:ok, _} = Documents.import_documents(coll_name, body, action: "create")

    update =
      %{
        "price" => "5.25"
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %Documents{num_deleted: nil, num_updated: num_updated}} =
             Documents.update_documents(coll_name, update, filter_by: "shoes_id:>=0")

    assert num_updated > 0
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
      |> Enum.map_join("\n", &Jason.encode_to_iodata!/1)

    assert {:ok, _} = Documents.import_documents(coll_name, body, action: "create")
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
      |> Jason.encode_to_iodata!()

    assert {:ok, %{shoes_id: ^shoes_id}} = Documents.index_document(coll_name, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collection overrides", %{coll_name: coll_name} do
    assert {:error, %ApiResponse{message: _}} =
             Documents.get_search_overrides("wrong_collection")

    {:ok, %SearchOverridesResponse{overrides: overrides}} =
      Documents.get_search_overrides(coll_name)

    assert overrides >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: get a non-existent override", %{coll_name: coll_name} do
    assert {:error, %ApiResponse{message: _}} =
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
      |> Jason.encode_to_iodata!()

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
      |> Enum.map_join("\n", &Jason.encode_to_iodata!/1)

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

    assert {:error, %ApiResponse{message: _}} =
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
    assert {:error, %ApiResponse{message: _}} =
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
      |> Jason.encode_to_iodata!()

    assert {:ok, %SearchOverride{}} =
             Documents.upsert_search_override(coll_name, "customize-apple", body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "field" do
    assert [num_deleted: :integer] = Documents.__fields__(:delete_documents_200_json_resp)
    assert [num_updated: :integer] = Documents.__fields__(:update_documents_200_json_resp)
  end
end
