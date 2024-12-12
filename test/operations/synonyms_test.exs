defmodule SynonymsTest do
  use ExUnit.Case

  alias OpenApiTypesense.Synonyms
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.SearchSynonym
  alias OpenApiTypesense.SearchSynonymsResponse

  setup_all do
    schema = %{
      name: "clothes",
      fields: [
        %{name: "cloth_name", type: "string", facet: true},
        %{name: "clothes_id", type: "int32"}
      ],
      default_sorting_field: "clothes_id"
    }

    collection_name = schema.name

    {:ok, %CollectionResponse{name: ^collection_name}} =
      schema
      |> Jason.encode_to_iodata!()
      |> Collections.create_collection()

    on_exit(fn ->
      {:ok, _} = Collections.delete_collection(collection_name)
    end)

    %{coll_name: collection_name}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collection synonyms", %{coll_name: coll_name} do
    assert {:ok, %SearchSynonymsResponse{synonyms: synonyms}} =
             Synonyms.get_search_synonyms(coll_name)

    assert length(synonyms) >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert a collection synonym", %{coll_name: coll_name} do
    body =
      %{
        "root" => "hat",
        "synonyms" => ["fedora", "cap", "visor"]
      }
      |> Jason.encode_to_iodata!()

    synonym_id = "hat-synonyms"

    {:ok, syn} = Synonyms.upsert_search_synonym(coll_name, synonym_id, body)
    assert synonym_id === syn.id
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete a collection synonym", %{coll_name: coll_name} do
    body =
      %{
        "root" => "sweater",
        "synonyms" => ["ribbed", "turtleneck", "v-neck", "half-zip"]
      }
      |> Jason.encode_to_iodata!()

    synonym_id = "sweater-synonyms"

    assert {:ok, %SearchSynonym{id: ^synonym_id}} =
             Synonyms.upsert_search_synonym(coll_name, synonym_id, body)

    assert {:ok, %{id: ^synonym_id}} = Synonyms.delete_search_synonym(coll_name, synonym_id)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: get a collection synonym", %{coll_name: coll_name} do
    body =
      %{
        "root" => "t-shirt",
        "synonyms" => ["waffle", "crew neck", "cotton", "tank top", "turtleneck", "mock neck"]
      }
      |> Jason.encode_to_iodata!()

    synonym_id = "t-shirt-synonyms"

    {:ok, %SearchSynonym{}} =
      Synonyms.upsert_search_synonym(coll_name, synonym_id, body)

    assert {:ok, %SearchSynonym{id: ^synonym_id}} =
             Synonyms.get_search_synonym(coll_name, synonym_id)
  end
end
