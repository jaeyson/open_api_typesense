import Config

config :open_api_typesense,
  api_key: "xyz",
  host: "localhost",
  port: 8108,
  scheme: "http",
  # see https://hexdocs.pm/req/Req.html#new/1
  options: [
    retry: false
  ]

config :oapi_generator,
  default: [
    renderer: OpenApiTypesense.Plugins.Renderer,
    output: [
      base_module: OpenApiTypesense,
      location: "lib/open_api_typesense",
      operation_subdirectory: "operations/",
      schema_subdirectory: "schemas/",
      schema_use: OpenApiTypesense.Encoder
    ]
  ]
