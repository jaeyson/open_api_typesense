defmodule NlSearchModelsTest do
  use ExUnit.Case, async: true

  # alias OpenApiTypesense.Connection
  # alias OpenApiTypesense.NlSearchModels

  setup_all do
    # conn = Connection.new()
    # map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    # on_exit(fn ->
    # end)

    # %{conn: conn, map_conn: map_conn}
    :ok
  end

  @tag [nls: true]
  # test "success: get a specific key", %{conn: conn, map_conn: map_conn} do
  test "success: get a specific key" do
    assert 1 === false
  end
end
