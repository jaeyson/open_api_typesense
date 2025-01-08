# OpenApiTypesense

Restful client for Typesense with adherence to Open API spec 3 (formerly Swagger)

[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-green)](https://github.com/jaeyson/open_api_typesense/pulls/app%2Fdependabot)
[![Hex.pm](https://img.shields.io/hexpm/v/open_api_typesense)](https://hex.pm/packages/open_api_typesense)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/open_api_typesense)
[![Hex.pm](https://img.shields.io/hexpm/l/open_api_typesense)](https://hexdocs.pm/open_api_typesense/license.html)
[![Typesense badge](https://img.shields.io/badge/Typesense-v27.1-darkblue)](https://typesense.org/docs/27.1/api)
[![Coverage Status](https://coveralls.io/repos/github/jaeyson/open_api_typesense/badge.svg?branch=main)](https://coveralls.io/github/jaeyson/open_api_typesense?branch=main)
[![CI Status](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `open_api_typesense` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:open_api_typesense, "~> 0.5"}

    # Or from GitHub repository, if you want the latest greatest from main branch
    {:open_api_typesense, git: "https://github.com/jaeyson/open_api_typesense.git"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/open_api_typesense>.

## Getting started

### Adding credentials

Spin up local Typesense instance

```bash
docker compose up -d

# check if "peer refreshed" in logs
docker container logs --follow --tail 50 typesense
```

```elixir
# e.g. config/runtime.exs
if config_env() == :prod do # if you'll use this in prod environment
  config :open_api_typesense,
    api_key: "xyz",
    host: "localhost",
    port: 8108,
    scheme: "http"
  ...
```

> **Note**: The `options` key can be used to pass additional configuration options such as custom Finch instance or receive timeout settings. You can add any options supported by Req here. For more details check [Req documentation](https://hexdocs.pm/req/Req.Steps.html#run_finch/1-request-options).

> **Note**: If you use this for adding tests in your app, you might want to add this in `config/test.exs`:

For Cloud hosted, you can generate and obtain the credentials from cluster instance admin interface:

```elixir
config :open_api_typesense,
  api_key: "credential", # Admin API key
  host: "111222333aaabbbcc-9.x9.typesense.net", # Nodes
  port: 443,
  scheme: "https"
```

## Using a another HTTP client

In order to use another HTTP client, OpenApiTypesense has a
callback function ([Behaviours](https://hexdocs.pm/elixir/typespecs.html#behaviours))
called `request` that contains 2 args:

1. `conn`: your connection map
2. `params`: payload, header, and client-related stuffs.

> #### `conn` and `params` {: .info}
>
> you can change the name `conn` and/or `params` however you want,
> since it's just a variable.

Here's a custom client example ([`HTTPoison`](https://hexdocs.pm/httpoison/readme.html))
in order to match the usage:

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

    request = %HTTPoison.Request{method: params.method, url: url}

    request =
      if params[:request] do
        [{content_type, _schema}] = params.request
        
        headers = [
          {"X-TYPESENSE-API-KEY", conn.api_key}
          {"Content-Type", content_type}
        ]

        %{request | headers: headers}
      else
        request
      end

    request =
      if params[:body] do
        %{request | body: Jason.encode!(params.body)}
      else
        request
      end

    HTTPoison.request!(request)
  end
end
```

Then add your client in your config file:

```elixir
config :open_api_typesense,
  api_key: "credential", # Admin API key
  host: "111222333aaabbbcc-9.x9.typesense.net", # Nodes
  port: 443,
  scheme: "https",
  client: MyApp.CustomClient # <- add this
```

And here's a reference taken from one of functions from [`Collections`](https://hexdocs.pm/open_api_typesense/OpenApiTypesense.Collections.html#create_collection/3), as
you may want to match the params:

```elixir
def create_collection(%Connection{} = conn, body, opts) when is_struct(conn) do
  client = opts[:client] || @default_client
  query = Keyword.take(opts, [:src_name])

  client.request(conn, %{
    args: [body: body],
    call: {OpenApiTypesense.Collections, :create_collection},
    url: "/collections",
    body: body,
    method: :post,
    query: query,
    request: [{"application/json", {OpenApiTypesense.CollectionSchema, :t}}],
    response: [
      {201, {OpenApiTypesense.CollectionResponse, :t}},
      {400, {OpenApiTypesense.ApiResponse, :t}},
      {409, {OpenApiTypesense.ApiResponse, :t}}
    ],
    opts: opts
  })
end
```

Check [the examples](./guides/custom_http_client.md) on some HTTP client implementations.
