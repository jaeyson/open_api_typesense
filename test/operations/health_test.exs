defmodule HealthTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Health
  alias OpenApiTypesense.HealthStatus

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: health check" do
    assert Health.health() === {:ok, %HealthStatus{ok: true}}
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

  #   assert Health.health(conn) === {:error, "timeout"}
  # end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: health check non-existing domain" do
    conn =
      Connection.new(%{
        api_key: "wrong_key",
        host: "wrong_host",
        port: 8108,
        scheme: "http"
      })

    assert Health.health(conn, []) === {:error, "non-existing domain"}
  end
end
