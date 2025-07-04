# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## major.minor.patch (yyyy.mm.dd)

## 1.0.4 (2025.06.18)

### Fixed
* Refactor `renderer.ex`, `client.ex` and operation schemas for consistently returning appropriate types [PR #33](https://github.com/jaeyson/open_api_typesense/pull/33).

### Added
* [Poison](https://hex.pm/packages/poison) library for custom json decoder.
* Use fork version of [`open-api-generator`](https://github.com/jaeyson/open-api-generator), for adding `default` value in `defstruct` declarations.
* Module (`OpenApiTypesense.Converter`) for maps/structs with mixed keys to full atom key conversions. 

## 1.0.3 (2025.06.16)

### Chore

* Add few documents tests
* Add custom encoder for JSON encoding all schemas.
* Typespecs and client definitions to use snake casing for consistency.
* Add custom renderer plugin for OpenAPI code gen.
* Use fork version for open-api-generator, with added `default` field for generated schema.

## 1.0.2 (2025.06.08)

### Fixed

* Reduce unsafe atom keys conversion. [PR #30](https://github.com/jaeyson/open_api_typesense/pull/30)

## 1.0.1 (2025.06.06)

### Fixed

* Typespecs for Documents and Stemmings. See [`ex_typesense` issue](https://github.com/jaeyson/ex_typesense/issues/80)

## 1.0.0 (2025.05.31)

### Changed

* Passing `conn` as part of `opts` when calling a function, as this reduces code duplication. [Issue #26](https://github.com/jaeyson/open_api_typesense/issues/26) [PR #29](https://github.com/jaeyson/open_api_typesense/pull/29)

### Chore

* Bumped dev dependencies

## 0.7.1 (2025.04.06)

### Fixed

* Parsing results from using multi search [unions](https://typesense.org/docs/28.0/api/federated-multi-search.html#union-search)

## 0.7.0 (2025.04.06)

### Changed ([#28](https://github.com/jaeyson/open_api_typesense/pull/28))

* Update to include Typesense [v28.0](https://typesense.org/docs/28.0/api)
* Removed deprecated functions in `OpenApiTypesense.Client`
* Bump dependency versions.
* Renamed `search` to `search_collection` from `Documents` module.

### Added

* Tests for [stemming](https://typesense.org/docs/28.0/api/stemming.html)
* Doc version tags

## 0.6.5 (2025.03.23)

### Changed ([#25](https://github.com/jaeyson/open_api_typesense/pull/25))

* the client now accepts all options defined in Req.new/1
* global configuration can be set in config.exs
* per-function call overrides are possible using the req argument
* the Req client configuration has been deprecated and moved from the Client module to the Connection module

## 0.6.4 (2025.02.16)

### Added

* Separate dev and test environments.
* JOINs tests.

### Changed

* No timeouts during tests.
* Bump dependency versions.

## 0.6.3 (2025.01.30)

### Removed

* Logic for checking environment during test.

## 0.6.2 (2025.01.26)

### Added

* Tests for [JOIns](https://typesense.org/docs/latest/api/joins.html)

### Changed

* Handle unknown HTTP status response
* Use [`config_env/0`](https://hexdocs.pm/elixir/Config.html#config_env/0) instead of [`Mix.env/0`](https://hexdocs.pm/mix/Mix.html#env/0)

## 0.6.1 (2025.01.19)

### Added

* `401` status code for unauthorized access

## 0.6.0 (2025.01.19)

### Changed

* CI to support Typesense versions v26.0, v27.0, v27.1

### Removed

* Support for Typesense version v0.25.2

## 0.5.2 (2025.01.16)

### Changed

* Documentation typos
* Tidy documentation flow

### Added

* Error status code missing from creating a snapshot
* More test coverage

## 0.5.1 (2025.01.12)

### Removed

* `filter_by` option from `Documents.update_document`.

## 0.5.0 (2025.01.08)

### Added

* User(s) can use another HTTP client instead of default ([Req](https://hexdocs.pm/req)).

### Changed

* Update docs
* Static to Dynamic fetching of application name for connection defaults.
* Update docs and include few anchor links.
* Update specific test where async is disabled when using [`Application.put_env/4`](https://elixirforum.com/t/using-application-get-env-application-put-env-in-exunit-tests/8019/2)

## 0.4.3 (2024.12.27)

### Changed

* Formatting `open_api.yml` file.
* Bump `ex_doc`
* Typo in `:oapi_generator` config for dev environment.

## 0.4.2 (2024.12.22)

### Added

* More tests for coverage
* Options for some functions
* Endpoints, params for `priv/open_api.yml`

## 0.4.1 (2024.12.19)

### Changed

* Disable protocol consolidation during dev or test (for `mix docs`).

## 0.4.0 (2024.12.17)

### Changed

* Typespecs for each functions

## 0.3.0 (2024.12.15)

### Changed

* HTTP request construction in `OpenApiTypesense.Client` to include `options`.

### Added

* `options` in config `config/config.exs`.
* `get_options/0` function in `Client` to fetch the `options` configuration.
* tests for `get_options/0` in `ClientTest`.

## 0.2.1 (2024.12.15)

### Changed

* Update consistency in docs

## 0.2.0 (2024.12.14)

### Changed

* Bumped dependencies

### Added

* Default client, currently using [`Req`](https://hexdocs.pm/req).
* `Connection` module, which is taken from [`ExTypesense`](https://hexdocs.pm/ex_typesense) because someone requested for loading of credentials at runtime.
* `defstruct` in Modules `Debug`, `Documents` and `Stopwords` because it is throwing undefined struct error.
* Few descriptions in `priv/open_api.yml` for 4XX response.

## 0.1.0 (2024.11.08)

* Initial release
