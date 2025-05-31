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

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: health check", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %HealthStatus{ok: true}} = Health.health()
    assert {:ok, %HealthStatus{ok: true}} = Health.health([])
    assert {:ok, %HealthStatus{ok: true}} = Health.health(conn: conn)
    assert {:ok, %HealthStatus{ok: true}} = Health.health(conn: map_conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: health check timeout" do
    conn =
      Connection.new(%{
        api_key: "wrong_key",
        host: "17.17.17.17",
        port: 8108,
        scheme: "http"
      })

    assert {:error, "timeout"} = Health.health(conn: conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: health check connection refused" do
    conn =
      Connection.new(%{
        api_key: "wrong_key",
        host: "localhost",
        port: 8119,
        scheme: "http"
      })

    assert {:error, "connection refused"} = Health.health(conn: conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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

    assert {:error, "non-existing domain"} = Health.health(conn: conn)
    assert {:error, "non-existing domain"} = Health.health(conn: map_conn)
  end
end
