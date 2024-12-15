defmodule ClientTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Client

  setup do
    # Backup the original configuration
    original_config = Application.get_env(:open_api_typesense, :options, %{})

    on_exit(fn ->
      # Restore the original configuration after each test
      Application.put_env(:open_api_typesense, :options, original_config)
    end)
  end

  describe "get_options/0" do
    @tag ["27.1": true, "26.0": true, "0.25.2": true]
    test "returns the configured options" do
      Application.put_env(:open_api_typesense, :options, %{
        finch: MyApp.CustomFinch,
        receive_timeout: 5_000
      })

      assert Client.get_options() == %{finch: MyApp.CustomFinch, receive_timeout: 5_000}
    end

    @tag ["27.1": true, "26.0": true, "0.25.2": true]
    test "returns an empty map if options is not configured" do
      Application.delete_env(:open_api_typesense, :options)

      assert Client.get_options() == %{}
    end
  end
end
