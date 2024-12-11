defmodule OverrideTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Override

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: retrieve an override" do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Override.get_search_override("helmets", 1)
  end
end
