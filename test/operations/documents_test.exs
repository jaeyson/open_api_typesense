defmodule DocumentsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Documents
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.MultiSearchResult
  alias OpenApiTypesense.SearchOverride
  alias OpenApiTypesense.SearchOverridesResponse
  alias OpenApiTypesense.SearchResult

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

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

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^name}} = Collections.delete_collection(name)
    end)

    %{coll_name: name, conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: update a document", %{coll_name: coll_name} do
    body = %{
      "shoes_id" => 12_299,
      "shoe_type" => "outdoor",
      "description" => "Under Armour Men's Ignite Select Slide Sandal",
      "price" => "usd 29.99"
    }

    assert {:ok, %{id: document_id}} = Documents.index_document(coll_name, body)

    shoe_type = "athletic shoes"

    body = %{"shoe_type" => shoe_type}

    assert {:ok, %{shoe_type: ^shoe_type}} =
             Documents.update_document(coll_name, document_id, body)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: update a non-existent document", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    body =
      %{
        "shoe_type" => "athletic shoes"
      }

    document_id = 9999
    message = "Could not find a document with id: #{document_id}"

    opts = [dirty_values: "coerce_or_reject"]

    assert {:error, %ApiResponse{message: ^message}} =
             Documents.update_document(coll_name, document_id, body)

    assert {:error, _} = Documents.update_document(coll_name, document_id, body, opts)
    assert {:error, _} = Documents.update_document(coll_name, document_id, body, conn: conn)
    assert {:error, _} = Documents.update_document(coll_name, document_id, body, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: search a document", %{coll_name: coll_name, conn: conn, map_conn: map_conn} do
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

    assert {:ok, _} = Documents.import_documents(coll_name, body)

    opts = [q: "sheepskin", query_by: "description", enable_analytics: false]
    assert {:ok, %SearchResult{hits: hits}} = Documents.search_collection(coll_name, opts)

    assert length(hits) === 2

    assert {:ok, _} = Documents.search_collection(coll_name, List.flatten([conn: conn], opts))
    assert {:ok, _} = Documents.search_collection(coll_name, List.flatten([conn: map_conn], opts))
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: update non-existent documents", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    body =
      [
        %{"id" => "9981", "price" => "usd 1.00"},
        %{"id" => "9982", "price" => "usd 1.00"}
      ]

    opts = [action: "update", importDocumentsParameters: %{batch_size: 100}]

    assert {:ok, [%{"success" => false}, %{"success" => false}]} =
             Documents.import_documents(coll_name, body, opts)

    assert {:ok, _} = Documents.import_documents(coll_name, body)
    assert {:ok, _} = Documents.import_documents(coll_name, body, conn: conn)
    assert {:ok, _} = Documents.import_documents(coll_name, body, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: multi-search with no documents", %{conn: conn, map_conn: map_conn} do
    body =
      %{
        "searches" => [
          %{"collection" => "shoes", "q" => "Nike", "query_by" => "description"},
          %{"collection" => "shoes", "q" => "Adidas", "query_by" => "description"}
        ]
      }

    params = [enable_analytics: false]
    assert {:ok, %MultiSearchResult{results: results}} = Documents.multi_search(body)

    [result_one, result_two] = results

    assert result_one.found === 0
    assert result_two.found === 0

    assert {:ok, _} = Documents.multi_search(body, params)
    assert {:ok, _} = Documents.multi_search(body, conn: conn)
    assert {:ok, _} = Documents.multi_search(body, conn: map_conn)
    assert {:ok, _} = Documents.multi_search(body, List.flatten([conn: conn], params))
    assert {:ok, _} = Documents.multi_search(body, List.flatten([conn: map_conn], params))
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: update documents by query", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
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

    assert {:ok, _} = Documents.import_documents(coll_name, body, action: "create")

    update =
      %{
        "price" => "5.25"
      }

    assert {:ok, %Documents{num_deleted: nil, num_updated: num_updated}} =
             Documents.update_documents(coll_name, update, filter_by: "shoes_id:>=0")

    assert num_updated > 0

    assert {:ok, _} =
             Documents.update_documents(coll_name, update, conn: conn, filter_by: "shoes_id:>=0")

    assert {:ok, _} =
             Documents.update_documents(coll_name, update,
               conn: map_conn,
               filter_by: "shoes_id:>=0"
             )
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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

    assert {:ok, _} = Documents.import_documents(coll_name, body, action: "create")
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: index a document", %{coll_name: coll_name, conn: conn, map_conn: map_conn} do
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

    assert {:ok, %{shoes_id: ^shoes_id}} = Documents.index_document(coll_name, body)
    assert {:ok, _} = Documents.index_document(coll_name, body, [])
    assert {:ok, _} = Documents.index_document(coll_name, body, conn: conn)
    assert {:ok, _} = Documents.index_document(coll_name, body, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list collection overrides", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:error, %ApiResponse{message: _}} =
             Documents.get_search_overrides("wrong_collection")

    assert {:ok, %SearchOverridesResponse{overrides: overrides}} =
             Documents.get_search_overrides(coll_name)

    assert overrides >= 0

    assert {:error, _} = Documents.get_search_overrides("xyz", [])
    assert {:error, _} = Documents.get_search_overrides("xyz", conn: conn)
    assert {:error, _} = Documents.get_search_overrides("xyz", conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: get a non-existent override", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:error, %ApiResponse{message: _}} =
             Documents.get_search_override(coll_name, "non-existent")

    assert {:error, _} = Documents.get_search_override(coll_name, "xyz", [])
    assert {:error, _} = Documents.get_search_override(coll_name, "xyz", conn: conn)
    assert {:error, _} = Documents.get_search_override(coll_name, "xyz", conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: delete a non-existent override", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:error, %ApiResponse{message: "Could not find that `id`."}} =
             Documents.delete_search_override(coll_name, "non-existent")

    assert {:error, _} = Documents.delete_search_override(coll_name, "xyz", [])
    assert {:error, _} = Documents.delete_search_override(coll_name, "xyz", conn: conn)
    assert {:error, _} = Documents.delete_search_override(coll_name, "xyz", conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete a document", %{coll_name: coll_name, conn: conn, map_conn: map_conn} do
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

    {:ok, %{id: id, shoes_id: ^shoes_id}} = Documents.index_document(coll_name, body)

    assert {:ok, %{id: ^id}} = Documents.delete_document(coll_name, id)

    error = "Could not find a document with id: #{id}"

    assert {:error, %ApiResponse{message: ^error}} =
             Documents.delete_document(coll_name, id, [])

    assert {:error, _} = Documents.delete_document(coll_name, id, conn: conn)
    assert {:error, _} = Documents.delete_document(coll_name, id, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete all documents", %{coll_name: coll_name, conn: conn, map_conn: map_conn} do
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

    assert {:ok, _} = Documents.import_documents(coll_name, body)

    opts = [filter_by: "shoes_id:>=0", batch_size: 100]

    assert {:ok, %Documents{num_deleted: _, num_updated: nil}} =
             Documents.delete_documents(coll_name, opts)

    assert {:ok, _} = Documents.delete_documents(coll_name, opts)
    assert {:ok, _} = Documents.delete_documents(coll_name, List.flatten([conn: conn], opts))
    assert {:ok, _} = Documents.delete_documents(coll_name, List.flatten([conn: map_conn], opts))
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: get a non-existent document", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    document_id = 9999
    message = "Could not find a document with id: #{document_id}"

    assert {:error, %ApiResponse{message: ^message}} =
             Documents.get_document(coll_name, document_id)

    assert {:error, _} = Documents.get_document(coll_name, document_id, [])
    assert {:error, _} = Documents.get_document(coll_name, document_id, conn: conn)
    assert {:error, _} = Documents.get_document(coll_name, document_id, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: export document from a non-existent collection", %{conn: conn, map_conn: map_conn} do
    opts = [exclude_fields: "fields"]

    assert {:error, %ApiResponse{message: _}} =
             Documents.export_documents("non-existent-collection")

    assert {:error, _} = Documents.export_documents("xyz", opts)
    assert {:error, _} = Documents.export_documents("xyz", conn: conn)
    assert {:error, _} = Documents.export_documents("xyz", conn: map_conn)
    assert {:error, _} = Documents.export_documents("xyz", List.flatten([conn: conn], opts))
    assert {:error, _} = Documents.export_documents("xyz", List.flatten([conn: map_conn], opts))
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: upsert a search override", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
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

    assert {:ok, %SearchOverride{}} =
             Documents.upsert_search_override(coll_name, "customize-apple", body)

    assert {:ok, _} = Documents.upsert_search_override(coll_name, "customize-apple", body, [])

    assert {:ok, _} =
             Documents.upsert_search_override(coll_name, "customize-apple", body, conn: conn)

    assert {:ok, _} =
             Documents.upsert_search_override(coll_name, "customize-apple", body, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "field" do
    assert [num_deleted: :integer] = Documents.__fields__(:delete_documents_200_json_resp)
    assert [num_updated: :integer] = Documents.__fields__(:update_documents_200_json_resp)
  end
end
