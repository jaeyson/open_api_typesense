defmodule HealthTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Health
  alias OpenApiTypesense.HealthStatus

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: health check", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %HealthStatus{ok: true}} = Health.health()
    assert {:ok, %HealthStatus{ok: true}} = Health.health([])
    assert {:ok, %HealthStatus{ok: true}} = Health.health(conn)
    assert {:ok, %HealthStatus{ok: true}} = Health.health(map_conn)
    assert {:ok, %HealthStatus{ok: true}} = Health.health(conn, [])
    assert {:ok, %HealthStatus{ok: true}} = Health.health(map_conn, [])
  end

  # Note: adding this test will add 5+ seconds!
  # @tag ["27.1": true, "26.0": true, "0.25.2": true]
  # test "error: health check timeout" do
  #   conn =
  #     Connection.new(%{
  #       api_key: "wrong_key",
  #       host: "127.1.1.1",
  #       port: 8108,
  #       scheme: "http"
  #     })

  #   assert Health.health(conn, []) === {:error, "timeout"}
  # end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: health check non-existing domain" do
    conn = %{
      api_key: "wrong_key",
      host: "wrong_host",
      port: 8108,
      scheme: "http"
    }

    map_conn =
      Connection.new(%{
        api_key: "wrong_key",
        host: "wrong_host",
        port: 8108,
        scheme: "http"
      })

    assert {:error, "non-existing domain"} = Health.health(conn)
    assert {:error, "non-existing domain"} = Health.health(map_conn)
  end
end
