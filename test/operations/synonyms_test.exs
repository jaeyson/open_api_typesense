defmodule SynonymsTest do
  use ExUnit.Case

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Synonyms
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.SearchSynonym
  alias OpenApiTypesense.SearchSynonymsResponse
  alias OpenApiTypesense.SynonymItemDeleteSchema
  alias OpenApiTypesense.SynonymItemSchema
  alias OpenApiTypesense.SynonymSetDeleteSchema
  alias OpenApiTypesense.SynonymSetSchema

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    schema = %{
      name: "clothes",
      fields: [
        %{name: "cloth_name", type: "string", facet: true},
        %{name: "clothes_id", type: "int32"}
      ],
      default_sorting_field: "clothes_id"
    }

    collection_name = schema.name

    {:ok, %CollectionResponse{name: ^collection_name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, _} = Collections.delete_collection(collection_name)

      synonym_sets =
        case Synonyms.retrieve_synonym_sets() do
          {:ok, sets} ->
            sets

          {:error, _reason} ->
            []
        end

      if Enum.any?(synonym_sets) do
        Enum.each(synonym_sets, fn set ->
          {:ok, _set} = Synonyms.delete_synonym_set(set.name)
        end)
      end
    end)

    %{coll_name: collection_name, conn: conn, map_conn: map_conn}
  end

  @tag ["30.0": true]
  test "error (v30.0): deprecated function for list collection synonyms", %{coll_name: coll_name} do
    error = {:error, %ApiResponse{message: "Not Found"}}
    assert ^error = Synonyms.get_search_synonyms(coll_name)
  end

  @tag ["29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list collection synonyms", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, %SearchSynonymsResponse{synonyms: synonyms}} =
             Synonyms.get_search_synonyms(coll_name)

    assert {:ok, %SearchSynonymsResponse{synonyms: ^synonyms}} =
             Synonyms.get_search_synonyms(coll_name, [])

    assert {:ok, %SearchSynonymsResponse{synonyms: ^synonyms}} =
             Synonyms.get_search_synonyms(coll_name, conn: conn)

    assert {:ok, %SearchSynonymsResponse{synonyms: ^synonyms}} =
             Synonyms.get_search_synonyms(coll_name, conn: map_conn)
  end

  @tag ["30.0": true]
  test "error (v30.0): deprecated function for upsert a collection synonym", %{
    coll_name: coll_name
  } do
    body =
      %{
        "root" => "hat",
        "synonyms" => ["fedora", "cap", "visor"]
      }

    synonym_id = "hat-synonyms"

    error = {:error, %ApiResponse{message: "Not Found"}}
    assert ^error = Synonyms.upsert_search_synonym(coll_name, synonym_id, body)
  end

  @tag ["29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: upsert a collection synonym", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    body =
      %{
        "root" => "hat",
        "synonyms" => ["fedora", "cap", "visor"]
      }

    synonym_id = "hat-synonyms"

    assert {:ok, syn} = Synonyms.upsert_search_synonym(coll_name, synonym_id, body)
    assert synonym_id === syn.id

    assert {:ok, _} = Synonyms.upsert_search_synonym(coll_name, synonym_id, body, [])
    assert {:ok, _} = Synonyms.upsert_search_synonym(coll_name, synonym_id, body, conn: conn)
    assert {:ok, _} = Synonyms.upsert_search_synonym(coll_name, synonym_id, body, conn: map_conn)
  end

  @tag ["30.0": true]
  test "error (v30.0): deprecated function for delete a collection synonym", %{
    coll_name: coll_name
  } do
    body =
      %{
        "root" => "sweater",
        "synonyms" => ["ribbed", "turtleneck", "v-neck", "half-zip"]
      }

    synonym_id = "sweater-synonyms"

    error = {:error, %ApiResponse{message: "Not Found"}}
    assert ^error = Synonyms.upsert_search_synonym(coll_name, synonym_id, body)
  end

  @tag ["29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete a collection synonym", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    body =
      %{
        "root" => "sweater",
        "synonyms" => ["ribbed", "turtleneck", "v-neck", "half-zip"]
      }

    synonym_id = "sweater-synonyms"

    assert {:ok, %SearchSynonym{id: ^synonym_id}} =
             Synonyms.upsert_search_synonym(coll_name, synonym_id, body)

    assert {:ok, %{id: ^synonym_id}} = Synonyms.delete_search_synonym(coll_name, synonym_id)
    assert {:error, _} = Synonyms.delete_search_synonym(coll_name, synonym_id, [])
    assert {:error, _} = Synonyms.delete_search_synonym(coll_name, synonym_id, conn: conn)
    assert {:error, _} = Synonyms.delete_search_synonym(coll_name, synonym_id, conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: delete a synonym set item", %{conn: conn, map_conn: map_conn} do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)

    item_id = "smart-phone-synonyms"

    body = %{
      "root" => "smart phone",
      "synonyms" => ["iphone", "android"]
    }

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body)

    assert {:ok, %SynonymItemDeleteSchema{id: ^item_id}} =
             Synonyms.delete_synonym_set_item(name, item_id)

    error = {:error, %ApiResponse{message: "Could not find that `id`."}}
    assert ^error = Synonyms.delete_synonym_set_item(name, item_id, [])
    assert ^error = Synonyms.delete_synonym_set_item(name, item_id, conn: conn)
    assert ^error = Synonyms.delete_synonym_set_item(name, item_id, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "error (v30.0): deprecate function delete a synonym associated with a collection", %{
    coll_name: coll_name
  } do
    synonym_id = "t-shirt-synonyms"
    error = {:error, %ApiResponse{message: "Not Found"}}
    assert ^error = Synonyms.delete_search_synonym(coll_name, synonym_id)
  end

  @tag ["30.0": true]
  test "success: list all synonym sets", %{conn: conn, map_conn: map_conn} do
    name = "sample"

    body = %{
      "items" => [
        %{
          "id" => "coat-synonyms",
          "synonyms" => ["blazer", "coat", "jacket"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)

    assert {:ok, synonym_sets} = Synonyms.retrieve_synonym_sets()
    assert Enum.any?(synonym_sets)
    assert {:ok, _} = Synonyms.retrieve_synonym_sets([])
    assert {:ok, _} = Synonyms.retrieve_synonym_sets(conn: conn)
    assert {:ok, _} = Synonyms.retrieve_synonym_sets(map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: retrieve a synonym set", %{conn: conn, map_conn: map_conn} do
    name = "sample"

    body = %{
      "items" => [
        %{
          "id" => "coat-synonyms",
          "synonyms" => ["blazer", "coat", "jacket"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)
    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.retrieve_synonym_set(name)
    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.retrieve_synonym_set(name, [])
    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.retrieve_synonym_set(name, conn: conn)

    assert {:ok, %SynonymSetSchema{name: ^name}} =
             Synonyms.retrieve_synonym_set(name, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: retrieve a synonym set item", %{conn: conn, map_conn: map_conn} do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)

    item_id = "smart-phone-synonyms"

    body = %{
      "root" => "smart phone",
      "synonyms" => ["iphone", "android"]
    }

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body)

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.retrieve_synonym_set_item(name, item_id)

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.retrieve_synonym_set_item(name, item_id, [])

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.retrieve_synonym_set_item(name, item_id, conn: conn)

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.retrieve_synonym_set_item(name, item_id, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: retrieve a synonym set items", %{conn: conn, map_conn: map_conn} do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)

    item_id = "smart-phone-synonyms"

    body = %{
      "root" => "smart phone",
      "synonyms" => ["iphone", "android"]
    }

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body)

    assert {:ok, set_items} = Synonyms.retrieve_synonym_set_items(name)
    assert Enum.any?(set_items)
    assert {:ok, _} = Synonyms.retrieve_synonym_set_items(name, [])
    assert {:ok, _} = Synonyms.retrieve_synonym_set_items(name, conn: conn)
    assert {:ok, _} = Synonyms.retrieve_synonym_set_items(name, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "error (v30.0): deprecated function for get a collection synonym", %{coll_name: coll_name} do
    synonym_id = "t-shirt-synonyms"
    error = {:error, %ApiResponse{message: "Not Found"}}
    assert ^error = Synonyms.get_search_synonym(coll_name, synonym_id)
  end

  @tag ["29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: get a collection synonym", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    body =
      %{
        "root" => "t-shirt",
        "synonyms" => ["waffle", "crew neck", "cotton", "tank top", "turtleneck", "mock neck"]
      }

    synonym_id = "t-shirt-synonyms"

    assert {:ok, %SearchSynonym{}} =
             Synonyms.upsert_search_synonym(coll_name, synonym_id, body)

    assert {:ok, %SearchSynonym{id: ^synonym_id}} =
             Synonyms.get_search_synonym(coll_name, synonym_id)

    assert {:ok, _} = Synonyms.get_search_synonym(coll_name, synonym_id, [])
    assert {:ok, _} = Synonyms.get_search_synonym(coll_name, synonym_id, conn: conn)
    assert {:ok, _} = Synonyms.get_search_synonym(coll_name, synonym_id, conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: create or update a synonym set (multi-way synonym)", %{
    conn: conn,
    map_conn: map_conn
  } do
    name = "sample"

    body = %{
      "items" => [
        %{
          "id" => "coat-synonyms",
          "synonyms" => ["blazer", "coat", "jacket"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)
    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body, [])

    assert {:ok, %SynonymSetSchema{name: ^name}} =
             Synonyms.upsert_synonym_set(name, body, conn: conn)

    assert {:ok, %SynonymSetSchema{name: ^name}} =
             Synonyms.upsert_synonym_set(name, body, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: create or update a synonym set (one-way synonym)", %{
    conn: conn,
    map_conn: map_conn
  } do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)
    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body, [])

    assert {:ok, %SynonymSetSchema{name: ^name}} =
             Synonyms.upsert_synonym_set(name, body, conn: conn)

    assert {:ok, %SynonymSetSchema{name: ^name}} =
             Synonyms.upsert_synonym_set(name, body, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: upsert a synonym set item", %{conn: conn, map_conn: map_conn} do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)

    item_id = "smart-phone-synonyms"

    body = %{
      "root" => "smart phone",
      "synonyms" => ["iphone", "android"]
    }

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body)

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body, [])

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body, conn: conn)

    assert {:ok, %SynonymItemSchema{id: ^item_id}} =
             Synonyms.upsert_synonym_set_item(name, item_id, body, map_conn: map_conn)
  end

  @tag ["30.0": true]
  test "success: delete a synonym set", %{conn: conn, map_conn: map_conn} do
    name = "tech-synonyms"

    body = %{
      "items" => [
        %{
          "id" => "smart-phone-synonyms",
          "root" => "smart phone",
          "synonyms" => ["iphone", "android"]
        }
      ]
    }

    assert {:ok, %SynonymSetSchema{name: ^name}} = Synonyms.upsert_synonym_set(name, body)
    assert {:ok, %SynonymSetDeleteSchema{name: ^name}} = Synonyms.delete_synonym_set(name)

    error = {:error, %ApiResponse{message: "Synonym index not found"}}
    assert ^error = Synonyms.delete_synonym_set(name, [])
    assert ^error = Synonyms.delete_synonym_set(name, conn: conn)
    assert ^error = Synonyms.delete_synonym_set(name, map_conn: map_conn)
  end
end
