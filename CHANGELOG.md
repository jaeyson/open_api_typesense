# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## major.minor.patch (yyyy.mm.dd)

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
