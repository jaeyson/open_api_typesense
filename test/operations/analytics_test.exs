defmodule AnalyticsTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Analytics

  alias OpenApiTypesense.Analytics
  alias OpenApiTypesense.AnalyticsRulesRetrieveSchema

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list analytics rules" do
    assert {:ok, %AnalyticsRulesRetrieveSchema{}} = Analytics.retrieve_analytics_rules()
  end
end
