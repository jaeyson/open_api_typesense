defmodule PresetsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Presets
  alias OpenApiTypesense.PresetsRetrieveSchema
  alias OpenApiTypesense.PresetSchema
  alias OpenApiTypesense.PresetDeleteSchema

  setup_all do
    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "food_chains", "q" => "*", "sort_by" => "ratings"}
          ]
        }
      }
      |> Jason.encode!()

    {:ok, %PresetSchema{}} = Presets.upsert_preset("food_chain_view", body)

    on_exit(fn ->
      {:ok, %PresetsRetrieveSchema{presets: presets}} = Presets.retrieve_all_presets()
      Enum.map(presets, &Presets.delete_preset(&1.name))
    end)

    :ok
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list presets" do
    assert {:ok, %PresetsRetrieveSchema{presets: presets}} = Presets.retrieve_all_presets()
    assert length(presets) >= 1
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: get a preset" do
    assert {:error, %ApiResponse{message: "Not found."}} = Presets.retrieve_preset("listing_view")
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert a preset" do
    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "restaurants", "q" => "*", "sort_by" => "popularity"}
          ]
        }
      }
      |> Jason.encode!()

    assert {:ok, %PresetSchema{name: "restaurant_view"}} =
             Presets.upsert_preset("restaurant_view", body)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete a preset" do
    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "companies", "q" => "*", "sort_by" => "shares"}
          ]
        }
      }
      |> Jason.encode!()

    assert {:ok, %PresetSchema{name: "company_view"}} =
             Presets.upsert_preset("company_view", body)

    assert {:ok, %PresetDeleteSchema{name: "company_view"}} =
             Presets.delete_preset("company_view")
  end
end
