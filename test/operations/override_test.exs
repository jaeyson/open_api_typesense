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

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: retrieve an override", %{conn: conn, map_conn: map_conn} do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Override.get_search_override("helmets", 1)

    assert {:error, _} = Override.get_search_override("helmets", 1, [])
    assert {:error, _} = Override.get_search_override(conn, "helmets", 1)
    assert {:error, _} = Override.get_search_override(map_conn, "helmets", 1)
    assert {:error, _} = Override.get_search_override(conn, "helmets", 1, [])
    assert {:error, _} = Override.get_search_override(map_conn, "helmets", 1, [])
  end
end
