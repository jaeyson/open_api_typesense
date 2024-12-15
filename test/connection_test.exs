defmodule ConnectionTest do
  use ExUnit.Case, async: true
  doctest OpenApiTypesense.Connection

  alias OpenApiTypesense.Connection

  test "new/0 using the default config to creates a connection struct" do
    conn = Connection.new()

    assert conn == %Connection{
             api_key: "xyz",
             host: "localhost",
             port: 8108,
             scheme: "http"
           }
  end

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

  test "new/1 with empty map raises ArgumentError" do
    msg = "Missing required fields: [:api_key, :host, :port, :scheme]"
    assert_raise ArgumentError, msg, fn -> Connection.new(%{}) end
  end

  test "new/1 with invalid data type raises ArgumentError" do
    assert_raise ArgumentError, fn -> Connection.new("invalid") end
  end
end
