defmodule OperationsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiStatsResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Operations
  alias OpenApiTypesense.SuccessStatus

  @rate_limit :timer.seconds(5)

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: retrieve api stats", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats()
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats([])
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats(conn)
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats(map_conn)
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats(conn, [])
    assert {:ok, %ApiStatsResponse{}} = Operations.retrieve_api_stats(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: retrieve metrics", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics()
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics([])
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics(conn)
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics(map_conn)
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics(conn, [])
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: toggle threshold time for request log", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %SuccessStatus{success: true}} =
             Operations.config(%{"log_slow_requests_time_ms" => 2_000})

    body = %{"log_slow_requests_time_ms" => -1}
    assert {:ok, %SuccessStatus{success: true}} = Operations.config(body, [])
    assert {:ok, %SuccessStatus{success: true}} = Operations.config(conn, body)
    assert {:ok, %SuccessStatus{success: true}} = Operations.config(map_conn, body)
    assert {:ok, %SuccessStatus{success: true}} = Operations.config(conn, body, [])
    assert {:ok, %SuccessStatus{success: true}} = Operations.config(map_conn, body, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: clear cache", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache()
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache([])
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache(conn)
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache(map_conn)
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache(conn, [])
    assert {:ok, %SuccessStatus{success: true}} = Operations.clear_cache(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: compact database", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact()
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact([])
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact(conn)
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact(map_conn)
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact(conn, [])
    assert {:ok, %SuccessStatus{success: true}} = Operations.compact(map_conn, [])
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: take snapshot", %{conn: conn, map_conn: map_conn} do
    params = [snapshot_path: "/tmp/typesense-data-snapshot"]

    assert {:ok, %SuccessStatus{success: true}} = Operations.take_snapshot(params)

    Process.sleep(@rate_limit)
    assert {:ok, %SuccessStatus{success: true}} = Operations.take_snapshot(conn, params)

    Process.sleep(@rate_limit)
    assert {:ok, %SuccessStatus{success: true}} = Operations.take_snapshot(map_conn, params)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: re-elect leader", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote()
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote([])
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote(conn)
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote(map_conn)
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote(conn, [])
    assert {:ok, %SuccessStatus{success: false}} = Operations.vote(map_conn, [])
  end

  @tag ["28.0": true, "27.1": false, "27.0": false, "26.0": false]
  test "success: get schema changes", %{conn: conn, map_conn: map_conn} do
    assert {:ok, schemas} = Operations.get_schema_changes()
    assert length(schemas) >= 0

    assert {:ok, _} = Operations.get_schema_changes([])
    assert {:ok, _} = Operations.get_schema_changes(conn)
    assert {:ok, _} = Operations.get_schema_changes(map_conn)
    assert {:ok, _} = Operations.get_schema_changes(conn, [])
    assert {:ok, _} = Operations.get_schema_changes(map_conn, [])
  end
end
