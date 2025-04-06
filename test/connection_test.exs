defmodule ConnectionTest do
  use ExUnit.Case, async: true
  # doctest OpenApiTypesense.Connection

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Health

  @forbidden %ApiResponse{
    message: "Forbidden - a valid `x-typesense-api-key` header must be sent."
  }

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "new/0 using the default config to creates a connection struct" do
    assert Connection.new() === %Connection{
             api_key: "xyz",
             host: "localhost",
             port: 8108,
             scheme: "http",
             options: [retry: false]
           }
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "new/1 with custom fields creates a connection struct" do
    conn =
      Connection.new(%{
        host: "otherhost",
        port: 9200,
        scheme: "https",
        api_key: "myapikey"
      })

    assert conn === %Connection{
             api_key: "myapikey",
             host: "otherhost",
             port: 9200,
             scheme: "https",
             options: [retry: false]
           }
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: wrong api key was configured" do
    conn = %{
      host: "localhost",
      api_key: "another_key",
      port: 8108,
      scheme: "http"
    }

    assert {:error, @forbidden} == Collections.get_collections(conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: overriding config with a wrong API key" do
    conn = %{
      host: "localhost",
      api_key: "another_key",
      port: 8108,
      scheme: "http"
    }

    assert {:error, @forbidden} = Collections.get_collections(conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: health check, with incorrect port number" do
    conn = %{api_key: "xyz", host: "localhost", port: 8100, scheme: "http"}

    assert {:error, "connection refused"} = Health.health(conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "error: health check, with incorrect host" do
    conn = %{api_key: "xyz", host: "my_test_host", port: 8108, scheme: "http"}

    assert {:error, "non-existing domain"} = Health.health(conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "new/1 with Connection struct" do
    conn = Connection.new()
    assert %Connection{} = Connection.new(conn)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "new/1 with empty map raises ArgumentError" do
    error = assert_raise ArgumentError, fn -> Connection.new(%{}) end

    assert error.message === "Missing required fields: [:api_key, :host, :port, :scheme]"
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
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
