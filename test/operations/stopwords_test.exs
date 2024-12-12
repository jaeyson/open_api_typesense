defmodule StopwordsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Stopwords
  alias OpenApiTypesense.StopwordsSetSchema
  alias OpenApiTypesense.StopwordsSetRetrieveSchema
  alias OpenApiTypesense.StopwordsSetsRetrieveAllSchema

  setup_all do
    on_exit(fn ->
      {:ok, %StopwordsSetsRetrieveAllSchema{stopwords: stopwords}} =
        Stopwords.retrieve_stopwords_sets()

      stopwords
      |> Enum.each(fn stopword ->
        Stopwords.delete_stopwords_set(stopword.id)
      end)
    end)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: list stopwords sets" do
    assert {:ok, %StopwordsSetsRetrieveAllSchema{stopwords: stopwords}} =
             Stopwords.retrieve_stopwords_sets()

    assert length(stopwords) >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: add stopwords" do
    set_id = "stopword_set_countries"

    body =
      %{
        "stopwords" => ["Germany", "France", "Italy", "United States"],
        "locale" => "en"
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: retrieve specific stopwords set" do
    set_id = "stopword_set_names"

    body =
      %{
        "stopwords" => ["Bustin Jieber", "Pelvis Presly", "Tinus Lorvalds", "Britney Smears"],
        "locale" => "en"
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)

    assert {:ok, %StopwordsSetRetrieveSchema{stopwords: %{id: ^set_id}}} =
             Stopwords.retrieve_stopwords_set(set_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: delete specific stopwords set" do
    set_id = "stopword_set_companies"

    body =
      %{
        "stopwords" => ["Loca Cola", "Burgler King", "Buttweiser", "Lowcoste"],
        "locale" => "en"
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %StopwordsSetSchema{id: ^set_id}} = Stopwords.upsert_stopwords_set(set_id, body)
    assert {:ok, %Stopwords{id: ^set_id}} = Stopwords.delete_stopwords_set(set_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "field" do
    assert [id: {:string, :generic}] = Stopwords.__fields__(:delete_stopwords_set_200_json_resp)
  end
end
