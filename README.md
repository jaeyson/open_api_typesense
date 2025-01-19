# OpenApiTypesense

Restful client for Typesense with adherence to Open API spec 3 (formerly Swagger)

[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-green)](https://github.com/jaeyson/open_api_typesense/pulls/app%2Fdependabot)
[![Hex.pm](https://img.shields.io/hexpm/v/open_api_typesense)](https://hex.pm/packages/open_api_typesense)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/open_api_typesense)
[![Hex.pm](https://img.shields.io/hexpm/l/open_api_typesense)](https://hexdocs.pm/open_api_typesense/license.html)
[![Typesense badge](https://img.shields.io/badge/Typesense-v26.0_%7C_v27.0_%7C_v27.1-darkblue)](https://typesense.org/docs/27.1/api)
[![Coverage Status](https://coveralls.io/repos/github/jaeyson/open_api_typesense/badge.svg?branch=main)](https://coveralls.io/github/jaeyson/open_api_typesense?branch=main)
[![CI Status](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `open_api_typesense` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:open_api_typesense, "~> 0.6"}

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

> #### `options` key {: .tip}
>
> The `options` key can be used to pass additional configuration
> options such as custom Finch instance or receive timeout
> settings. You can add any options supported by Req here. For
> more details check [Req documentation](https://hexdocs.pm/req/Req.Steps.html#run_finch/1-request-options).

```
config :open_api_typesense,
  api_key: "credential", # Admin API key
  host: "111222333aaabbbcc-9.x9.typesense.net", # Nodes
  port: 443,
  scheme: "https"
  options: [finch: MyApp.CustomFinch] # <- add options
```

> #### during tests {: .tip}
>
> If you have a different config for your app, consider 
> adding it in `config/test.exs`.


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

<!-- tabs-open -->

### Client module

```elixir
defmodule MyApp.CustomClient do
  @behaviour OpenApiTypesense.Client
  
  @impl OpenApiTypesense.Client
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

### Client config

```elixir
config :open_api_typesense,
  api_key: "xyz", # Admin API key
  host: "localhost", # Nodes
  port: 8108,
  scheme: "http",
  client: MyApp.CustomClient # <- add this
```

<!-- tabs-close -->

Check [the examples](./guides/custom_http_client.md) on some HTTP client implementations.

## Adding [cache, retry, compress_body](https://hexdocs.pm/req/Req.html#new/1) in the built in client

E.g. when a user wants to change `retry` and `cache` options

```elixir
ExTypesense.get_collection("companies", req: [retry: false, cache: true])
```

See implementation [OpenApiTypesense.Client](`OpenApiTypesense.Client`) https://github.com/jaeyson/open_api_typesense/blob/main/lib/open_api_typesense/client.ex

