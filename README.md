# OpenApiTypesense

Restful client for Typesense with adherence to Open API spec 3 (formerly Swagger)

[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-green)](https://github.com/jaeyson/open_api_typesense/pulls/app%2Fdependabot)
[![Hex.pm](https://img.shields.io/hexpm/v/open_api_typesense)](https://hex.pm/packages/open_api_typesense)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/open_api_typesense)
[![Hex.pm](https://img.shields.io/hexpm/l/open_api_typesense)](https://hexdocs.pm/open_api_typesense/license.html)
[![Typesense badge](https://img.shields.io/badge/Typesense-v27.1-darkblue)](https://typesense.org/docs/27.1/api)
[![Coverage Status](https://coveralls.io/repos/github/jaeyson/open_api_typesense/badge.svg?branch=main)](https://coveralls.io/github/jaeyson/open_api_typesense?branch=main)
[![CI Status](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jaeyson/open_api_typesense/actions/workflows/ci.yml)

## TODO
- Custom Http client adapter (currently [`Req`](https://hexdocs.pm/req))

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `open_api_typesense` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:open_api_typesense, "~> 0.3"}

    # Or from GitHub repository, if you want to latest greatest from main branch
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
    scheme: "http",
    options: %{}
  ...
```

> **Note**: The `options` key can be used to pass additional configuration options such as custom Finch instance or receive timeout settings. You can add any options supported by Req here. For more details check [Req documentation](https://hexdocs.pm/req/Req.Steps.html#run_finch/1-request-options).

> **Note**: If you use this for adding test in your app, you might want to add this in `config/test.exs`:

For Cloud hosted, you can generate and obtain the credentials from cluster instance admin interface:

```elixir
config :open_api_typesense,
  api_key: "credential", # Admin API key
  host: "111222333aaabbbcc-9.x9.typesense.net", # Nodes
  port: 443,
  scheme: "https",
  options: %{}
```
