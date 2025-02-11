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
