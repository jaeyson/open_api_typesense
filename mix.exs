defmodule OpenApiTypesense.MixProject do
  use Mix.Project

  @source_url "https://github.com/jaeyson/open_api_typesense"
  @hex_url "https://hexdocs.pm/open_api_typesense"
  @version "0.2.0"

  def project do
    [
      app: :open_api_typesense,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description:
        "Restful client for Typesense with adherence to Open API spec 3 (formerly Swagger)",
      docs: docs(),
      package: package(),
      name: "OpenApiTypesense",
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.34", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:req, "~> 0.5"},
      {:excoveralls, "~> 0.18", only: :test},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:oapi_generator, "~> 0.2", only: :dev, runtime: false, optional: true}
    ]
  end

  defp docs do
    [
      api_reference: false,
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      canonical: @hex_url,
      formatters: ["html"],
      extras: [
        "CHANGELOG.md",
        "README.md": [title: "Overview"],
        "LICENSE.md": [title: "License"]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Jaeyson Anthony Y."],
      licenses: ["MIT"],
      links: %{
        Github: @source_url,
        Changelog: "#{@hex_url}/changelog.html"
      }
    ]
  end
end
