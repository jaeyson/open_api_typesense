defmodule CurationTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Curation
  alias OpenApiTypesense.SearchOverride
  alias OpenApiTypesense.SearchOverridesResponse

  setup_all do
    name = "brands"

    schema =
      %{
        name: name,
        fields: [
          %{name: "brand_name", type: "string"},
          %{name: "#{name}_id", type: "int32"}
        ],
        default_sorting_field: "#{name}_id"
      }
      |> Jason.encode_to_iodata!()

    {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^name}} = Collections.delete_collection(name)
    end)

    %{schema_name: name}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert search override", %{schema_name: schema_name} do
    override_id = "customize-loca-cola"

    body =
      %{
        "rule" => %{
          "query" => "Loca Cola",
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

    assert {:ok, %SearchOverride{id: ^override_id}} =
             Curation.upsert_search_override(schema_name, override_id, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete search override", %{schema_name: schema_name} do
    message = "Could not find that `id`."

    assert {:error, %ApiResponse{message: ^message}} =
             Curation.delete_search_override(schema_name, "test")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collection overrides", %{schema_name: schema_name} do
    assert {:ok, %SearchOverridesResponse{overrides: overrides}} =
             Curation.get_search_overrides(schema_name)

    assert length(overrides) >= 0
  end
end
