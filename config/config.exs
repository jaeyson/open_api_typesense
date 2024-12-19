import Config

if Mix.env() in [:dev, :test] do
  config :open_api_typesense,
    api_key: "xyz",
    host: "localhost",
    port: 8108,
    scheme: "http"
end

if Mix.env() == :dev do
  config :oapi_generator,
    default: [
      output: [
        base_module: XOpenApiTypesense,
        location: "lib/x_open_api_typesense",
        operation_subdirectory: "operations/",
        schema_subdirectory: "schemas/"
      ]
    ]
end
