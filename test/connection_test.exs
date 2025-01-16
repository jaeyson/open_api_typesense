defmodule ConnectionTest do
  use ExUnit.Case, async: true
  # doctest OpenApiTypesense.Connection

  alias OpenApiTypesense.Connection

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "new/0 using the default config to creates a connection struct" do
    conn = Connection.new()

    assert conn == %Connection{
             api_key: "xyz",
             host: "localhost",
             port: 8108,
             scheme: "http"
           }
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "new/1 with custom fields creates a connection struct" do
    conn =
      Connection.new(%{
        host: "otherhost",
        port: 9200,
        scheme: "https",
        api_key: "myapikey"
      })

    assert conn == %Connection{
             api_key: "myapikey",
             host: "otherhost",
             port: 9200,
             scheme: "https"
           }
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "new/1 with empty map raises ArgumentError" do
    error = assert_raise ArgumentError, fn -> Connection.new(%{}) end

    assert error.message === "Missing required fields: [:api_key, :host, :port, :scheme]"
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "new/1 with invalid data type raises ArgumentError" do
    invalid_inputs = [
      nil,
      "string",
      123,
      [],
      [host: "localhost"]
    ]

    for input <- invalid_inputs do
      error =
        assert_raise ArgumentError, fn ->
          Connection.new(input)
        end

      assert error.message === "Expected a map for connection options"
    end
  end
end
