# Examples on using a custom HTTP client

> #### Add first the client name in config {: .info}
>
> Don't forget to add the client name!

```elixir
config :open_api_typesense,
  api_key: "credential", # Admin API key
  host: "111222333aaabbbcc-9.x9.typesense.net", # Nodes
  port: 443,
  scheme: "https",
  client: MyApp.CustomClient # <- this line
```

## [`:httpc`](https://www.erlang.org/doc/apps/inets/httpc.html)

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    uri = %URI{
      scheme: conn.scheme,
      host: conn.host,
      port: conn.port,
      path: params.url,
      query: URI.encode_query(params[:query] || %{})
    }

    [{content_type, _schema}] = params.request

    request = {
      URI.to_string(uri),
      [{~c"x-typesense-api-key", String.to_charlist(conn.api_key)}],
      String.to_charlist(content_type),
      Jason.encode!(params[:body])
    }

    {:ok, {_status, _header, body}} = :httpc.request(params.method, request, [], [])

    Jason.decode!(body)
  end
end
```

## [HTTPoison](https://hexdocs.pm/httpoison/readme.html)

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    url = %URI{
      scheme: conn.scheme,
      host: conn.host,
      port: conn.port,
      path: params.url,
      query: URI.encode_query(params[:query] || %{})
    }
    |> URI.to_string()

    body = Jason.encode!(params[:body])

    [{content_type, _schema}] = params.request

    headers = [{"Content-Type", content_type}]

    HTTPoison.request!(params.method, url, body, headers)
  end
end
```

## [`:hackney`](https://hexdocs.pm/hackney)

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    url = %URI{
      scheme: conn.scheme,
      host: conn.host,
      port: conn.port,
      path: params.url,
      query: URI.encode_query(params[:query] || %{})
    }
    |> URI.to_string()

    [{content_type, _schema}] = params.request

    headers = [
      {"x-typesense-api-key", conn.api_key},
      {"content-type", content_type}
    ]

    body = Jason.encode!(params[:body])

    case :hackney.request(params.method, url, headers, body, []) do
      {:ok, status, _headers, ref} when status in 200..299 ->
        {:ok, body} = :hackney.body(ref)
        Jason.decode(body)

      {:ok, status, _headers, ref} ->
        {:ok, body} = :hackney.body(ref)
        {:error, %{status: status, body: body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
```

## [Mint](https://hexdocs.pm/mint)

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    url = %URI{
      scheme: conn.scheme,
      host: conn.host,
      port: conn.port,
      path: params.url,
      query: URI.encode_query(params[:query] || %{})
    }
    |> URI.to_string()

    [{content_type, _schema}] = params.request

    headers = [
      {"x-typesense-api-key", conn.api_key},
      {"content-type", content_type}
    ]

    body = Jason.encode!(params[:body])

    # Start the connection
    with {:ok, conn} <- Mint.HTTP.connect(String.to_atom(conn.scheme), conn.host, conn.port),
         {:ok, conn, request_ref} <- Mint.HTTP.request(conn, to_string(params.method), url, headers, body),
         {:ok, _conn, responses} <- receive_responses(conn, []) do
      # Find the response associated with the request_ref
      case Enum.find(responses, fn
             {:status, ^request_ref, _} -> true
             _ -> false
           end) do
        {:status, ^request_ref, status} when status in 200..299 ->
          {:ok, body} = parse_body(responses, request_ref)
          Jason.decode(body)

        {:status, ^request_ref, status} ->
          {:ok, body} = parse_body(responses, request_ref)
          {:error, %{status: status, body: body}}

        _ ->
          {:error, "No response found"}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Helper to receive responses
  defp receive_responses(conn, acc) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
          :unknown ->
            {:ok, conn, acc}

          {:ok, conn, responses} ->
            receive_responses(conn, acc ++ responses)

          {:error, conn, reason, _responses} ->
            {:error, reason}
        end
    after
      5_000 ->
        {:ok, conn, acc}
    end
  end

  # Helper to parse the body
  defp parse_body(responses, request_ref) do
    body_chunks =
      Enum.reduce(responses, [], fn
        {:data, ^request_ref, chunk}, acc -> [chunk | acc]
        _, acc -> acc
      end)

    {:ok, IO.iodata_to_binary(Enum.reverse(body_chunks))}
  end
end
```

## [Finch](https://hexdocs.pm/finch)

Add to your supervision tree:

```elixir
# e.g. lib/my_app/application.ex
  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Githubber.Worker.start_link(arg)
      # {Githubber.Worker, arg}
      {Finch, name: MyFinch} # <- add this
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Githubber.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

```elixir
defmodule MyApp.CustomClient do
  def request(conn, _params) do
    uri = %URI{
      scheme: conn.scheme,
      host: conn.host,
      port: conn.port,
      path: params.url,
      query: URI.encode_query(params[:query] || %{})
    }
    |> URI.to_string()

    [{content_type, _schema}] = params.request

    headers = [
      {"x-typesense-api-key", conn.api_key},
      {"content-type", content_type}
    ]

    body = Jason.encode!(params[:body])

    # Perform the request using Finch
    case Finch.build(:put, url, headers, body)
         |> Finch.request(MyFinch) do
      {:ok, %Finch.Response{status: status, body: body}} when status in 200..299 ->
        Jason.decode(body)

      {:ok, %Finch.Response{status: status, body: body}} ->
        {:error, %{status: status, body: body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
```

## [Tesla](https://hexdocs.pm/tesla)

```elixir
# e.g. config/config.exs
import Config

config :tesla, adapter: Tesla.Adapter.Hackney
```

```elixir
# e.g. config/runtime.exs
config :open_api_typesense,
  api_key: "xyz",
  host: "localhost",
  port: 8108,
  scheme: "http",
  client: MyApp.CustomClient
```

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    url =
      %URI{
        scheme: conn.scheme,
        host: conn.host,
        port: conn.port,
        path: params.url
      }
      |> URI.to_string()

    body = Jason.encode!(params[:body])

    options = [
      method: params.method,
      url: url,
      query: params[:query],
      body: body
    ]

    [{content_type, _schema}] = params.request

    client =
      Tesla.client([
        {
          Tesla.Middleware.Headers,
          [
            {"x-typesense-api-key", conn.api_key},
            {"content-type", content_type}
          ]
        },
        Tesla.Middleware.JSON
      ])

    case Tesla.request(client, options) do
      {:ok, %Tesla.Env{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, %{status: status, body: body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
```

## [`:gun`](https://hexdocs.pm/gun)

```elixir
defmodule MyApp.CustomClient do
  def request(conn, params) do
    # Open a connection
    {:ok, pid} =
      :gun.open(String.to_charlist(conn.host), conn.port, %{
        protocols: [:http],
        transport: if(conn.scheme == "https", do: :tls, else: :tcp)
      })

    # Await the connection
    {:ok, _protocol} = :gun.await_up(pid)

    url = params.url <> URI.encode_query(params[:query] || %{})

    headers =
      if params[:request] do
        [{content_type, _schema}] = params[:request]

        [
          {"x-typesense-api-key", conn.api_key},
          {"content-type", content_type}
        ]
      else
        [{"x-typesense-api-key", conn.api_key}]
      end

    body = Jason.encode!(params[:body])

    # Make the PUT request
    # stream_ref = :gun.put(pid, url, headers, body)
    stream_ref =
      case params.method do
        :get -> :gun.get(pid, url, headers)
        :post -> :gun.post(pid, url, headers, body)
        :put -> :gun.put(pid, url, headers, body)
        :delete -> :gun.delete(pid, url, headers)
        :patch -> :gun.patch(pid, url, headers, body)
      end

    # Await the response
    case :gun.await(pid, stream_ref) do
      {:response, :fin, status, headers} ->
        # Handle response with no body
        :gun.close(pid)
        {:ok, {status, headers, ""}}

      {:response, :nofin, status, headers} ->
        # Handle response with body
        {:ok, body} = receive_body(pid, stream_ref)
        :gun.close(pid)

        # Parse the JSON response if content-type is application/json
        content_type =
          headers
          |> Enum.find(fn {key, _} -> String.downcase(key) == "content-type" end)
          |> elem(1)

        body =
          if String.contains?(content_type, "application/json") do
            case Jason.decode(body) do
              {:ok, decoded} -> decoded
              {:error, _} -> body
            end
          else
            body
          end

        {:ok, {status, headers, body}}

      {:error, _} = error ->
        :gun.close(pid)
        error
    end
  end

  # Helper function to receive the complete response body
  defp receive_body(pid, stream_ref, acc \\ "") do
    receive do
      {:gun_data, ^pid, ^stream_ref, :fin, data} ->
        {:ok, acc <> data}

      {:gun_data, ^pid, ^stream_ref, :nofin, data} ->
        receive_body(pid, stream_ref, acc <> data)

      {:gun_error, ^pid, ^stream_ref, reason} ->
        {:error, reason}

      {:gun_down, ^pid, _, _, _, _} ->
        {:error, :connection_down}
    after
      5_000 ->
        {:error, :timeout}
    end
  end
end
```
