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
    recipe_name = "recipes"

    recipe_schema =
      %{
        name: recipe_name,
        fields: [
          %{"name" => "recipe_name", "type" => "string"},
          %{"name" => "#{recipe_name}_id", "type" => "int32"},
          %{"name" => "description", "type" => "string"}
        ],
        default_sorting_field: "#{recipe_name}_id"
      }
      |> Jason.encode_to_iodata!()

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
      |> Jason.encode_to_iodata!()

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
      |> Jason.encode_to_iodata!()

    nohits_queries_name = "no_hits_queries"

    nohits_queries_schema =
      %{
        "name" => nohits_queries_name,
        "fields" => [
          %{"name" => "q", "type" => "string"},
          %{"name" => "count", "type" => "int32"}
        ]
      }
      |> Jason.encode_to_iodata!()

    recipe_nohits_queries_name = "recipe_no_hits_queries"

    recipe_nohits_queries_schema =
      %{
        "name" => recipe_nohits_queries_name,
        "fields" => [
          %{"name" => "q", "type" => "string"},
          %{"name" => "count", "type" => "int32"}
        ]
      }
      |> Jason.encode_to_iodata!()

    [
      recipe_schema,
      product_schema,
      product_queries_schema,
      nohits_queries_schema,
      recipe_nohits_queries_schema
    ]
    |> Enum.map(fn schema ->
      Collections.create_collection(schema)
    end)

    on_exit(fn ->
      {:ok, %CollectionResponse{name: ^recipe_name}} =
        Collections.delete_collection(recipe_name)

      {:ok, %CollectionResponse{name: ^product_name}} =
        Collections.delete_collection(product_name)

      {:ok, %CollectionResponse{name: ^product_queries_name}} =
        Collections.delete_collection(product_queries_name)

      {:ok, %CollectionResponse{name: ^nohits_queries_name}} =
        Collections.delete_collection(nohits_queries_name)

      {:ok, %CollectionResponse{name: ^recipe_nohits_queries_name}} =
        Collections.delete_collection(recipe_nohits_queries_name)

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
      |> Jason.encode_to_iodata!()

    message = "Collection `#{collection_name}` not found."
    assert {:error, %ApiResponse{message: ^message}} = Analytics.create_analytics_rule(body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert analytics rule" do
    name = "another_product_no_hits"

    body =
      %{
        "type" => "nohits_queries",
        "params" => %{
          "source" => %{
            "collections" => ["recipes"]
          },
          "destination" => %{
            "collection" => "recipe_no_hits_queries"
          },
          "limit" => 1_000
        }
      }
      |> Jason.encode_to_iodata!()

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
      |> Jason.encode_to_iodata!()

    assert {:error, %ApiResponse{message: _}} = Analytics.create_analytics_rule(body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list analytics rules" do
    assert {:ok, %AnalyticsRulesRetrieveSchema{rules: rules}} =
             Analytics.retrieve_analytics_rules()

    assert length(rules) >= 0
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: create analytics rule" do
    name = "product_queries_aggregation"

    body =
      %{
        "name" => name,
        "type" => "popular_queries",
        "params" => %{
          "source" => %{
            "collections" => ["products"]
          },
          "destination" => %{
            "collection" => "product_queries"
          },
          "limit" => 1_000
        }
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.create_analytics_rule(body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: retrieve analytics rule" do
    name = "product_no_hits"

    body =
      %{
        "name" => name,
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
      |> Jason.encode_to_iodata!()

    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.create_analytics_rule(body)
    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.retrieve_analytics_rule(name)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: create analytics event" do
    name = "product_downloads"

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
            "counter_field" => "downloads"
          }
        }
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %AnalyticsRuleSchema{name: ^name}} = Analytics.create_analytics_rule(body)

    name = "products_downloads_event"

    body =
      %{
        "name" => name,
        "type" => "click",
        "data" => %{
          "doc_id" => "2468",
          "user_id" => "9903"
        }
      }
      |> Jason.encode_to_iodata!()

    assert {:ok, %AnalyticsEventCreateResponse{ok: true}} = Analytics.create_analytics_event(body)
  end
end
