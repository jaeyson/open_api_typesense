defmodule DebugTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Debug

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Debug

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list stopwords sets", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %Debug{version: _}} = Debug.debug()
    assert {:ok, _} = Debug.debug([])
    assert {:ok, _} = Debug.debug(conn)
    assert {:ok, _} = Debug.debug(map_conn)
    assert {:ok, _} = Debug.debug(conn, [])
    assert {:ok, _} = Debug.debug(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "field" do
    assert [version: {:string, :generic}] = Debug.__fields__(:debug_200_json_resp)
  end
end
