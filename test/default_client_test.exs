defmodule DefaultClientTest do
  use ExUnit.Case, async: false

  alias OpenApiTypesense.Client
  alias OpenApiTypesense.Connection

  require Logger

  describe "request/2" do
    @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
    test "default to req http client if no custom client set" do
      conn = Connection.new()

      opts = %{
        args: [],
        call: {OpenApiTypesense.Health, :health},
        url: "/health",
        method: :get,
        response: [{200, {OpenApiTypesense.HealthStatus, :t}}],
        opts: [],
        conn: conn
      }

      assert {:ok, %OpenApiTypesense.HealthStatus{ok: true}} =
               Client.request(opts)
    end
  end

  describe "build_req_client/2" do
    @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
    test "override req options through req field" do
      req = Client.build_req_client(Connection.new(), req: [retry: true, cache: false])
      assert req.options == %{decode_json: [keys: :atoms], cache: false, retry: true}
    end
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "get api key" do
    assert "xyz" = Client.api_key()
  end
end
