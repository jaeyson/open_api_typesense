defmodule StemmingTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Stemming
  alias OpenApiTypesense.StemmingDictionary

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    id = "irregular-plurals"

    schema = %{
      "name" => "stemming_companies",
      "fields" => [
        %{"name" => "description", "type" => "string", "stem_dictionary" => id},
        %{"name" => "companies_id", "type" => "int32"}
      ],
      "default_sorting_field" => "companies_id"
    }

    {:ok, %CollectionResponse{}} = Collections.create_collection(schema)

    on_exit(fn ->
      Collections.delete_collection(schema["name"])
    end)

    %{id: id, conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "success: create stemming dictionaries", %{conn: conn, map_conn: map_conn} do
    id = "example-stemming"

    body = [
      %{"word" => "people", "root" => "person"},
      %{"word" => "children", "root" => "child"},
      %{"word" => "geese", "root" => "goose"}
    ]

    assert {:ok,
            [
              %{"root" => "person", "word" => "people"},
              %{"root" => "child", "word" => "children"},
              %{"root" => "goose", "word" => "geese"}
            ]} = Stemming.import_stemming_dictionary(body, id: id)

    assert {:ok,
            [
              %{"root" => "person", "word" => "people"},
              %{"root" => "child", "word" => "children"},
              %{"root" => "goose", "word" => "geese"}
            ]} = Stemming.import_stemming_dictionary(conn, body, id: id)

    assert {:ok,
            [
              %{"root" => "person", "word" => "people"},
              %{"root" => "child", "word" => "children"},
              %{"root" => "goose", "word" => "geese"}
            ]} = Stemming.import_stemming_dictionary(map_conn, body, id: id)
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "success: list stemming dictionaries", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries()
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries([])
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries(conn)
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries(map_conn)
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries(conn, [])
    assert {:ok, %Stemming{}} = Stemming.list_stemming_dictionaries(map_conn, [])
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "error: non-existent stemming dictionary" do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Stemming.get_stemming_dictionary("non-existent")
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "success: get specific stemming dictionary", %{id: id, conn: conn, map_conn: map_conn} do
    body = [
      %{"word" => "mice", "root" => "mouse"},
      %{"word" => "written", "root" => "write"},
      %{"word" => "driven", "root" => "drive"}
    ]

    assert {:ok,
            [
              %{"word" => "mice", "root" => "mouse"},
              %{"word" => "written", "root" => "write"},
              %{"word" => "driven", "root" => "drive"}
            ]} = Stemming.import_stemming_dictionary(body, id: id)

    assert {:ok, %StemmingDictionary{id: ^id}} = Stemming.get_stemming_dictionary(id)
    assert {:ok, %StemmingDictionary{id: ^id}} = Stemming.get_stemming_dictionary(id, [])
    assert {:ok, %StemmingDictionary{id: ^id}} = Stemming.get_stemming_dictionary(conn, id)
    assert {:ok, %StemmingDictionary{id: ^id}} = Stemming.get_stemming_dictionary(map_conn, id)
    assert {:ok, %StemmingDictionary{id: ^id}} = Stemming.get_stemming_dictionary(conn, id, [])

    assert {:ok, %StemmingDictionary{id: ^id}} =
             Stemming.get_stemming_dictionary(map_conn, id, [])
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "field" do
    assert [dictionaries: [string: :generic]] =
             Stemming.__fields__(:list_stemming_dictionaries_200_json_resp)
  end
end
