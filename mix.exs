defmodule OpenApiTypesense.MixProject do
  use Mix.Project

  @source_url "https://github.com/jaeyson/open_api_typesense"
  @hex_url "https://hexdocs.pm/open_api_typesense"
  @version "0.7.1"

  def project do
    [
      app: :open_api_typesense,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() not in [:dev, :test],
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
      {:excoveralls, "~> 0.18", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:oapi_generator, "~> 0.2", only: :dev, runtime: false, optional: true}
    ]
  end

  defp get_modules(path) do
    File.ls!("lib/open_api_typesense/#{path}")
    |> Enum.map(fn schema_name ->
      module_name =
        if schema_name == "api_stats_response.ex" do
          "APIStatsResponse"
        else
          schema_name
          |> Path.rootname()
          |> Macro.camelize()
        end

      Module.concat(OpenApiTypesense, module_name)
    end)
    |> Enum.sort()
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
        "README.md",
        "LICENSE.md": [title: "License"],
        "guides/custom_http_client.md": [title: "Custom HTTP Client"]
      ],
      nest_modules_by_prefix: [
        OpenApiTypesense
      ],
      groups_for_modules: [
        "Client-side": [
          OpenApiTypesense.Client,
          OpenApiTypesense.Connection
        ],
        Operations: get_modules("operations"),
        Schemas: get_modules("schemas")
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
