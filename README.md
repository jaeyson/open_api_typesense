# OpenApiTypesense

Restful client for Typesense with adherence to Open API spec 3 (formerly Swagger)

[![Hex.pm](https://img.shields.io/hexpm/v/open_api_typesense)](https://hex.pm/packages/open_api_typesense)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/open_api_typesense)
[![Coverage Status](https://coveralls.io/repos/github/jaeyson/open_api_typesense/badge.svg?branch=main)](https://coveralls.io/github/jaeyson/open_api_typesense?branch=main)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/965dd3f8866d49c3b3e82edd0f6270cb)](https://app.codacy.com/gh/jaeyson/open_api_typesense/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![codescenene Average Code Health](https://codescene.io/projects/63240/status-badges/average-code-health)](https://codescene.io/projects/63240)

[![CI v28.0](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v28.0.yml/badge.svg)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v28.0.yml)
[![CI v27.1](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v27.1.yml/badge.svg)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v27.1.yml)
[![CI v27.0](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v27.0.yml/badge.svg)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v27.0.yml)
[![CI v26.0](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v26.0.yml/badge.svg)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci_v26.0.yml)

[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-green)](https://github.com/jaeyson/open_api_typesense/pulls/app%2Fdependabot)
[![Hex.pm](https://img.shields.io/hexpm/l/open_api_typesense)](https://hexdocs.pm/open_api_typesense/license.html)
[![Latest Typesense compatible](https://img.shields.io/badge/Latest%20Typesense%20compatible-v28.0-%230F35BC)](https://typesense.org/docs/28.0/api)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `open_api_typesense` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:open_api_typesense, "~> 0.7"}

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

## Using another connection via maps

You might be using a connection that changes dynamically. You can pass it as a map:

```elixir
custom_conn = %{api_key: "xyz", host: "localhost", port: 8108, scheme: "http"}
OpenApiTypesense.Health(conn: conn)
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

