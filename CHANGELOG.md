# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## major.minor.patch (yyyy.mm.dd)

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
