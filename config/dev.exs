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
    # processor: OpenApiTypesense.Plugins.Processor,
    renderer: OpenApiTypesense.Plugins.Renderer,
    # naming: [
    #   field_casing: :snake
    # ],
    output: [
      base_module: OpenApiTypesense,
      location: "lib/open_api_typesense",
      operation_subdirectory: "operations/",
      schema_subdirectory: "schemas/",
      schema_use: OpenApiTypesense.Encoder
      # extra_fields: [__info__: :map]
    ]
  ]
