defmodule PresetsTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Presets
  alias OpenApiTypesense.PresetsRetrieveSchema
  alias OpenApiTypesense.PresetSchema
  alias OpenApiTypesense.PresetDeleteSchema

  setup_all do
    conn = Connection.new()
    map_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}

    %{conn: conn, map_conn: map_conn}

    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "food_chains", "q" => "*", "sort_by" => "ratings"}
          ]
        }
      }

    {:ok, %PresetSchema{}} = Presets.upsert_preset("food_chain_view", body)

    on_exit(fn ->
      {:ok, %PresetsRetrieveSchema{presets: presets}} = Presets.retrieve_all_presets()
      Enum.map(presets, &Presets.delete_preset(&1.name))
    end)

    %{conn: conn, map_conn: map_conn}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: list presets", %{conn: conn, map_conn: map_conn} do
    assert {:ok, %PresetsRetrieveSchema{presets: presets}} = Presets.retrieve_all_presets()
    assert length(presets) >= 1

    assert {:ok, _} = Presets.retrieve_all_presets([])
    assert {:ok, _} = Presets.retrieve_all_presets(conn)
    assert {:ok, _} = Presets.retrieve_all_presets(map_conn)
    assert {:ok, _} = Presets.retrieve_all_presets(conn, [])
    assert {:ok, _} = Presets.retrieve_all_presets(map_conn, [])
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: get a preset", %{conn: conn, map_conn: map_conn} do
    assert {:error, %ApiResponse{message: "Not found."}} = Presets.retrieve_preset("listing_view")
    assert {:error, _} = Presets.retrieve_preset("listing_view", [])
    assert {:error, _} = Presets.retrieve_preset(conn, "listing_view")
    assert {:error, _} = Presets.retrieve_preset(map_conn, "listing_view")
    assert {:error, _} = Presets.retrieve_preset(conn, "listing_view", [])
    assert {:error, _} = Presets.retrieve_preset(map_conn, "listing_view", [])
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: upsert a preset", %{conn: conn, map_conn: map_conn} do
    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "restaurants", "q" => "*", "sort_by" => "popularity"}
          ]
        }
      }

    assert {:ok, %PresetSchema{name: "restaurant_view"}} =
             Presets.upsert_preset("restaurant_view", body)

    assert {:ok, _} = Presets.upsert_preset("restaurant_view", body, [])
    assert {:ok, _} = Presets.upsert_preset(conn, "restaurant_view", body)
    assert {:ok, _} = Presets.upsert_preset(map_conn, "restaurant_view", body)
    assert {:ok, _} = Presets.upsert_preset(conn, "restaurant_view", body, [])
    assert {:ok, _} = Presets.upsert_preset(map_conn, "restaurant_view", body, [])
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "success: delete a preset", %{conn: conn, map_conn: map_conn} do
    body =
      %{
        "value" => %{
          "searches" => [
            %{"collection" => "companies", "q" => "*", "sort_by" => "shares"}
          ]
        }
      }

    assert {:ok, %PresetSchema{name: "company_view"}} =
             Presets.upsert_preset("company_view", body)

    assert {:ok, %PresetDeleteSchema{name: "company_view"}} =
             Presets.delete_preset("company_view")

    assert {:error, _} = Presets.delete_preset("company_view", [])
    assert {:error, _} = Presets.delete_preset(conn, "company_view")
    assert {:error, _} = Presets.delete_preset(map_conn, "company_view")
    assert {:error, _} = Presets.delete_preset(conn, "company_view", [])
    assert {:error, _} = Presets.delete_preset(map_conn, "company_view", [])
  end
end
