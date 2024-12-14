defmodule DebugTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Debug

  alias OpenApiTypesense.Debug

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list stopwords sets" do
    assert {:ok, %Debug{version: _}} = Debug.debug()
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "field" do
    assert [version: {:string, :generic}] = Debug.__fields__(:debug_200_json_resp)
  end
end
