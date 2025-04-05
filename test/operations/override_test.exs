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

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: retrieve an override", %{conn: conn, map_conn: map_conn} do
    assert {:error, %ApiResponse{message: "Not Found"}} =
             Override.get_search_override("helmets", "custom-helmet")

    assert {:error, _} = Override.get_search_override("helmets", "custom-helmet", [])
    assert {:error, _} = Override.get_search_override(conn, "helmets", "custom-helmet")
    assert {:error, _} = Override.get_search_override(map_conn, "helmets", "custom-helmet")
    assert {:error, _} = Override.get_search_override(conn, "helmets", "custom-helmet", [])
    assert {:error, _} = Override.get_search_override(map_conn, "helmets", "custom-helmet", [])
  end
end
