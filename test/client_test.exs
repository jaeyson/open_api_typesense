defmodule ClientTest do
  use ExUnit.Case, async: true

  defmodule CustomClient do
    def request(conn, params) do
      uri =
        %URI{
          scheme: conn.scheme,
          host: conn.host,
          port: conn.port,
          path: params.url,
          query: URI.encode_query(params[:query] || %{})
        }
        |> URI.to_string()

      headers = [{"x-typesense-api-key", conn.api_key}]

      request =
        if params[:request] do
          [{content_type, _schema}] = params.request
          body = Jason.encode!(params[:body] || %{})

          {
            String.to_charlist(uri),
            Enum.map(headers, &to_charlist_tuple/1),
            String.to_charlist(content_type),
            body
          }
        else
          {
            String.to_charlist(uri),
            Enum.map(headers, &to_charlist_tuple/1)
          }
        end

      case :httpc.request(params.method, request, [], []) do
        {:ok, {{_http_version, status_code, _status_message}, response_headers, body}} ->
          handle_response(status_code, response_headers, body)

        {:error, reason} ->
          Logger.error("HTTP request failed: #{inspect(reason)}")
          {:error, reason}
      end
    end

    defp handle_response(status_code, _headers, body) when status_code in 200..299 do
      case Jason.decode(body) do
        {:ok, decoded_body} ->
          {:ok, decoded_body}

        {:error, decode_error} ->
          Logger.error("Failed to decode JSON response: #{inspect(decode_error)}")
          {:error, :invalid_json}
      end
    end

    defp handle_response(status_code, _headers, body) do
      Logger.warn("Request failed with status #{status_code} and body: #{body}")
      {:error, %{status: status_code, body: body}}
    end

    defp to_charlist_tuple({key, value}) do
      {String.to_charlist(key), String.to_charlist(value)}
    end
  end

  setup do
    on_exit(fn ->
      Application.delete_env(:open_api_typesense, :options)
    end)
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "returns the configured options" do
    Application.put_env(:open_api_typesense, :options, %{
      finch: MyApp.CustomFinch,
      receive_timeout: 5_000
    })

    options = Application.get_env(:open_api_typesense, :options)

    assert options == %{finch: MyApp.CustomFinch, receive_timeout: 5_000}
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "returns an empty map if options is not configured" do
    Application.delete_env(:open_api_typesense, :options)

    options = Application.get_env(:open_api_typesense, :options)

    assert options == nil
  end

  @tag ["27.1": true, "26.0": true, "0.25.2": true]
  test "use another HTTP client" do
    map_conn = %{
      api_key: "xyz",
      host: "localhost",
      port: 8108,
      scheme: "http",
      client: CustomClient
    }

    conn = OpenApiTypesense.Connection.new(map_conn)

    Application.put_env(:open_api_typesense, :client, CustomClient)

    assert CustomClient == Application.get_env(:open_api_typesense, :client)

    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health()
    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health([])
    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health(conn)
    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health(map_conn)
    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health(conn, [])
    assert {:ok, %{"ok" => true}} == OpenApiTypesense.Health.health(map_conn, [])
  end
end
