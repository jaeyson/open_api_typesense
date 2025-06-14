defmodule StopwordsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Stopwords
  alias OpenApiTypesense.StopwordsSetSchema
  alias OpenApiTypesense.StopwordsSetRetrieveSchema
  alias OpenApiTypesense.StopwordsSetsRetrieveAllSchema

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    on_exit(fn ->
      {:ok, %StopwordsSetsRetrieveAllSchema{stopwords: stopwords}} =
        Stopwords.retrieve_stopwords_sets()

      stopwords
      |> Enum.each(fn stopword ->
        Stopwords.delete_stopwords_set(stopword.id)
      end)
    end)

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list stopwords sets", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %StopwordsSetsRetrieveAllSchema{stopwords: stopwords}} =
             Stopwords.retrieve_stopwords_sets()

    assert length(stopwords) >= 0
    assert {:ok, _} = Stopwords.retrieve_stopwords_sets([])
    assert {:ok, _} = Stopwords.retrieve_stopwords_sets(conn: conn)
    assert {:ok, _} = Stopwords.retrieve_stopwords_sets(conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: add stopwords", %{conn: conn, map_conn: map_conn} do
    set_id = "stopword_set_countries"

    body =
      %{
        "stopwords" => ["Germany", "France", "Italy", "United States"],
        "locale" => "en"
      }

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)
    assert {:ok, _} = Stopwords.upsert_stopwords_set(set_id, body, [])
    assert {:ok, _} = Stopwords.upsert_stopwords_set(set_id, body, conn: conn)
    assert {:ok, _} = Stopwords.upsert_stopwords_set(set_id, body, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: retrieve specific stopwords set", %{conn: conn, map_conn: map_conn} do
    set_id = "stopword_set_names"

    body =
      %{
        "stopwords" => ["Bustin Jieber", "Pelvis Presly", "Tinus Lorvalds", "Britney Smears"],
        "locale" => "en"
      }

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)

    assert {:ok, %StopwordsSetRetrieveSchema{stopwords: %{id: ^set_id}}} =
             Stopwords.retrieve_stopwords_set(set_id)

    assert {:ok, _} = Stopwords.retrieve_stopwords_set(set_id, [])
    assert {:ok, _} = Stopwords.retrieve_stopwords_set(set_id, conn: conn)
    assert {:ok, _} = Stopwords.retrieve_stopwords_set(set_id, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: delete specific stopwords set", %{conn: conn, map_conn: map_conn} do
    set_id = "stopword_set_companies"

    body =
      %{
        "stopwords" => ["Loca Cola", "Burgler King", "Buttweiser", "Lowcoste"],
        "locale" => "en"
      }

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)
    assert {:ok, %Stopwords{id: ^set_id}} = Stopwords.delete_stopwords_set(set_id)
    assert {:error, _} = Stopwords.delete_stopwords_set(set_id, [])
    assert {:error, _} = Stopwords.delete_stopwords_set(set_id, conn: conn)
    assert {:error, _} = Stopwords.delete_stopwords_set(set_id, conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "field" do
    assert [id: {:string, :generic}] = Stopwords.__fields__(:delete_stopwords_set_200_json_resp)
  end
end
