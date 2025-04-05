defmodule SynonymsTest do
  use ExUnit.Case

  alias OpenApiTypesense.Synonyms
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.SearchSynonym
  alias OpenApiTypesense.SearchSynonymsResponse

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
    end)

    %{coll_name: collection_name, conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list collection synonyms", %{
    coll_name: coll_name,
    conn: conn,
    map_conn: map_conn
  } do
    assert {:ok, %SearchSynonymsResponse{synonyms: synonyms}} =
             Synonyms.get_search_synonyms(coll_name)

    assert length(synonyms) >= 0

    assert {:ok, _} = Synonyms.get_search_synonyms(coll_name, [])
    assert {:ok, _} = Synonyms.get_search_synonyms(conn, coll_name)
    assert {:ok, _} = Synonyms.get_search_synonyms(map_conn, coll_name)
    assert {:ok, _} = Synonyms.get_search_synonyms(conn, coll_name, [])
    assert {:ok, _} = Synonyms.get_search_synonyms(map_conn, coll_name, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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
    assert {:ok, _} = Synonyms.upsert_search_synonym(conn, coll_name, synonym_id, body)
    assert {:ok, _} = Synonyms.upsert_search_synonym(map_conn, coll_name, synonym_id, body)
    assert {:ok, _} = Synonyms.upsert_search_synonym(conn, coll_name, synonym_id, body, [])
    assert {:ok, _} = Synonyms.upsert_search_synonym(map_conn, coll_name, synonym_id, body, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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
    assert {:error, _} = Synonyms.delete_search_synonym(conn, coll_name, synonym_id)
    assert {:error, _} = Synonyms.delete_search_synonym(map_conn, coll_name, synonym_id)
    assert {:error, _} = Synonyms.delete_search_synonym(conn, coll_name, synonym_id, [])
    assert {:error, _} = Synonyms.delete_search_synonym(map_conn, coll_name, synonym_id, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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

    {:ok, %SearchSynonym{}} =
      Synonyms.upsert_search_synonym(coll_name, synonym_id, body)

    assert {:ok, %SearchSynonym{id: ^synonym_id}} =
             Synonyms.get_search_synonym(coll_name, synonym_id)

    assert {:ok, _} = Synonyms.get_search_synonym(coll_name, synonym_id, [])
    assert {:ok, _} = Synonyms.get_search_synonym(conn, coll_name, synonym_id)
    assert {:ok, _} = Synonyms.get_search_synonym(map_conn, coll_name, synonym_id)
    assert {:ok, _} = Synonyms.get_search_synonym(conn, coll_name, synonym_id, [])
    assert {:ok, _} = Synonyms.get_search_synonym(map_conn, coll_name, synonym_id, [])
  end
end
