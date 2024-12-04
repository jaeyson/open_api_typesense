defmodule OperationsTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Operations

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.APIStatsResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Operations

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: retrieve api stats" do
    assert {:ok, %APIStatsResponse{}} = Operations.retrieve_api_stats()
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: retrieve metrics" do
    assert {:ok, %{system_cpu_active_percentage: _}} = Operations.retrieve_metrics()
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: take snapshot" do
    assert {:ok, %OpenApiTypesense.SuccessStatus{success: true}} =
             Operations.take_snapshot(snapshot_path: "/tmp/typesense-data-snapshot")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: re-elect leader" do
    assert {:ok, %OpenApiTypesense.SuccessStatus{success: false}} = Operations.vote()
  end
end
