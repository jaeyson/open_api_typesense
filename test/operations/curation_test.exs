defmodule CurationTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Curation

  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Curation
  alias OpenApiTypesense.SearchOverridesResponse

  setup_all do
    schema = %{
      name: "brands",
      fields: [
        %{name: "brand_name", type: "string"},
        %{name: "brands_id", type: "int32"}
      ],
      default_sorting_field: "brands_id"
    }

    on_exit(fn ->
      Collections.delete_collection(schema.name)
    end)

    %{schema: schema}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list collection overrides", %{schema: schema} do
    name = schema.name
    assert {:ok, %CollectionResponse{name: ^name}} = Collections.create_collection(schema)
    assert {:ok, %SearchOverridesResponse{overrides: []}} == Curation.get_search_overrides(name)
  end
end
