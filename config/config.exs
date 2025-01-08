import Config

if Mix.env() in [:dev, :test] do
  config :open_api_typesense,
    api_key: "xyz",
    host: "192.168.254.2",
    port: 8108,
    scheme: "http"
end

if config_env() in [:dev] do
  config :oapi_generator,
    default: [
      output: [
        base_module: OpenApiTypesense,
        location: "lib/open_api_typesense",
        operation_subdirectory: "operations/",
        schema_subdirectory: "schemas/"
      ]
    ]
end
