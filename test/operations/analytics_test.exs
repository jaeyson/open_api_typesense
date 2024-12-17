defmodule AnalyticsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Analytics
  alias OpenApiTypesense.AnalyticsRuleSchema
  alias OpenApiTypesense.AnalyticsRulesRetrieveSchema
  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.AnalyticsEventCreateResponse

  setup_all do
    product_name = "products"

    product_schema =
      %{
        name: product_name,
        fields: [
          %{"name" => "product_name", "type" => "string"},
          %{"name" => "#{product_name}_id", "type" => "int32"},
          %{"name" => "description", "type" => "string"},
          %{"name" => "title", "type" => "string"},
          %{"name" => "popularity", "type" => "int32", "optional" => true}
        ],
        default_sorting_field: "#{product_name}_id"
      }

    product_queries_name = "product_queries"

    product_queries_schema =
      %{
        "name" => product_queries_name,
        "fields" => [
          %{"name" => "q", "type" => "string"},
          %{"name" => "count", "type" => "int32"},
          %{"name" => "downloads", "type" => "int32", "optional" => true}
        ]
      }

    nohits_queries_name = "no_hits_queries"

    nohits_queries_schema =
      %{
        "name" => nohits_queries_name,
        "fields" => [
          %{"name" => "q", "type" => "string"},
          %{"name" => "count", "type" => "int32"}
        ]
      }

    [
      product_schema,
      product_queries_schema,
      nohits_queries_schema
    ]
    |> Enum.map(fn schema ->
      Collections.create_collection(schema)
    end)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^product_name}} =
        Collections.delete_collection(product_name)

      {:ok, %CollectionResponse{name: ^product_queries_name}} =
        Collections.delete_collection(product_queries_name)

      {:ok, %CollectionResponse{name: ^nohits_queries_name}} =
        Collections.delete_collection(nohits_queries_name)

      {:ok, %AnalyticsRulesRetrieveSchema{rules: rules}} = Analytics.retrieve_analytics_rules()
      Enum.map(rules, &Analytics.delete_analytics_rule(&1.name))
    end)

    :ok
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: create analytics rule with non-existent collection" do
    name = "products_missing_query"
    collection_name = "non_existent_collection"

    body =
      %{
        "name" => name,
        "type" => "counter",
        "params" => %{
          "source" => %{
            "collections" => ["products"],
            "events" => [
              %{"type" => "click", "weight" => 1, "name" => "products_downloads_event"}
            ]
          },
          "destination" => %{
            "collection" => collection_name,
            "counter_field" => "downloads"
          }
        }
      }

    assert {:error, %ApiResponse{message: _}} = Analytics.create_analytics_rule(body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": false]
  test "success: upsert analytics rule" do
    name = "product_no_hits"

    body =
      %{
        "type" => "nohits_queries",
        "params" => %{
          "source" => %{
            "collections" => ["products"]
          },
          "destination" => %{
            "collection" => "no_hits_queries"
          },
          "limit" => 1_000
        }
      }

    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.upsert_analytics_rule(name, body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "error: create analytics rule with wrong field" do
    name = "products_test_query"
    field_name = "wrong_field"

    body =
      %{
        "name" => name,
        "type" => "counter",
        "params" => %{
          "source" => %{
            "collections" => ["products"],
            "events" => [
              %{"type" => "click", "weight" => 1, "name" => "products_downloads_event"}
            ]
          },
          "destination" => %{
            "collection" => "product_queries",
            "counter_field" => field_name
          }
        }
      }

    assert {:error, %ApiResponse{message: _}} = Analytics.create_analytics_rule(body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list analytics rules" do
    assert {:ok, %AnalyticsRulesRetrieveSchema{rules: rules}} =
             Analytics.retrieve_analytics_rules()

    assert length(rules) >= 0
  end

  @tag ["27.1": true, "26.0": false, "0.25.2": false]
  test "success (v27.1): create analytics rule and event" do
    name = "product_popularity"

    event_name = "products_click_event#{System.unique_integer()}"

    body =
      %{
        "name" => name,
        "type" => "counter",
        "params" => %{
          "source" => %{
            "collections" => ["products"],
            "events" => [
              %{"type" => "click", "weight" => 1, "name" => event_name}
            ]
          },
          "destination" => %{
            "collection" => "products",
            "counter_field" => "popularity"
          }
        }
      }

    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.create_analytics_rule(body)
    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.retrieve_analytics_rule(name)

    body =
      %{
        "name" => event_name,
        "type" => "click",
        "data" => %{
          "q" => "nike_shoes",
          "doc_id" => "2468",
          "user_id" => "9903"
        }
      }

    # Here's the reason why v26.0 is not tested
    # Docs v26.0: https://typesense.org/docs/26.0/api/analytics-query-suggestions.html#sending-click-events
    # Problem: the response JSON body is actually {"ok": true
    # where it is missing a closing curly bracket "}"
    assert {:ok, %AnalyticsEventCreateResponse{ok: true}} =
             Analytics.create_analytics_event(body, [])
  end
end
