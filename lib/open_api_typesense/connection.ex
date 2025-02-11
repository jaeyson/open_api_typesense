defmodule OpenApiTypesense.Connection do
  @moduledoc since: "0.2.0"

  @moduledoc """
  Fetches credentials either from application env or map.
  """

  @derive {Inspect, except: [:api_key]}
  defstruct [
    :host,
    :api_key,
    :port,
    :scheme,
    :client,
    # see https://hexdocs.pm/req/Req.html#new/1
    options: []
  ]

  @typedoc since: "0.2.0"
  @type t() :: %{
          host: binary() | nil,
          api_key: binary() | nil,
          port: non_neg_integer() | nil,
          scheme: binary() | nil,
          client: list() | nil,
          options: list()
        }

  @doc """
  Setting new connection or using the default config.

  > #### On using this function {: .info}
  > Functions e.g. `OpenApiTypesense.Health.health/0` don't need to explicitly pass this
  > unless you want to use another connection. Also, `api_key` is hidden when invoking
  > this function.

  ## Examples

      iex> alias OpenApiTypesense.Connection
      ...> Connection.new()
      %OpenApiTypesense.Connection{
        host: "localhost",
        port: 8108,
        scheme: "http",
        api_key: "xyz"
      }

      iex> alias OpenApiTypesense.Connection
      ...> Connection.new(%{})
      ** (ArgumentError) Missing required fields: [:api_key, :host, :port, :scheme]

  """
  @doc since: "0.2.0"
  @spec new :: %__MODULE__{}
  def new, do: new(defaults())

  @doc since: "0.2.0"
  @spec new(t() | map()) :: %__MODULE__{}
  def new(%__MODULE__{} = conn) when is_struct(conn, __MODULE__) do
    conn
  end

  def new(conn) when is_map(conn) do
    missing_fields = Enum.sort(required_fields() -- Map.keys(conn))

    if missing_fields == [] do
      fields = Map.merge(defaults(), conn)
      struct(__MODULE__, fields)
    else
      raise ArgumentError, "Missing required fields: #{inspect(missing_fields)}"
    end
  end

  def new(_) do
    raise ArgumentError, "Expected a map for connection options"
  end

  @spec required_fields :: list(atom())
  defp required_fields do
    # Dropping :client key in order to make it optional
    # since a user might just use the default client (Req).
    # User needs explicitly pass :client in order to use
    # another HTTP client. See README.
    __MODULE__
    |> struct(%{})
    |> Map.drop([:__struct__, :client, :options])
    |> Map.keys()
  end

  @spec defaults :: map()
  defp defaults do
    %{
      host: config(:host),
      api_key: config(:api_key),
      port: config(:port),
      scheme: config(:scheme),
      client: config(:client),
      options: config(:options, [])
    }
  end

  @spec config(atom()) :: any()
  def config(key, default \\ nil) do
    Access.get(config(), key, default)
  end

  @spec config :: list()
  def config do
    Application.get_all_env(:open_api_typesense)
  end
end
