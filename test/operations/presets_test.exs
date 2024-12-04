defmodule PresetsTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Presets

  alias OpenApiTypesense.Presets
  alias OpenApiTypesense.PresetsRetrieveSchema

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list presets" do
    assert {:ok, %PresetsRetrieveSchema{presets: []}} = Presets.retrieve_all_presets()
  end
end
