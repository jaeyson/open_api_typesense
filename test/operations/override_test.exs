defmodule OverrideTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Override

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["30.1": true, "30.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: retrieve an override", %{conn: conn, map_conn: map_conn} do
    error = {:error, %ApiResponse{message: "Not Found"}}

    assert ^error = Override.get_search_override("helmets", "custom-helmet")
    assert ^error = Override.get_search_override("helmets", "custom-helmet", [])
    assert ^error = Override.get_search_override("helmets", "custom-helmet", conn: conn)
    assert ^error = Override.get_search_override("helmets", "custom-helmet", conn: map_conn)
  end

  @tag ["29.0": true]
  test "error (v29.0): retrieve an override", %{conn: conn, map_conn: map_conn} do
    error = {:error, %ApiResponse{message: "Collection not found"}}

    assert ^error = Override.get_search_override("helmets", "custom-helmet")
    assert ^error = Override.get_search_override("helmets", "custom-helmet", [])
    assert ^error = Override.get_search_override("helmets", "custom-helmet", conn: conn)
    assert ^error = Override.get_search_override("helmets", "custom-helmet", conn: map_conn)
  end
end
