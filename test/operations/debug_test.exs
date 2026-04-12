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

  @tag ["30.0": true, "29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: list stopwords sets", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %{"state" => 1, "version" => _}} = Debug.debug()
    assert {:ok, %{"state" => 1, "version" => _}} = Debug.debug([])
    assert {:ok, %{"state" => 1, "version" => _}} = Debug.debug(conn: conn)
    assert {:ok, %{"state" => 1, "version" => _}} = Debug.debug(conn: map_conn)
  end

  @tag ["30.0": true, "29.0": true, "28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "field" do
    assert [version: :string] = Debug.__fields__(:debug_200_json_resp)
  end
end
