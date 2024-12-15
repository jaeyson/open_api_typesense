# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## major.minor.patch (yyyy.mm.dd)

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
