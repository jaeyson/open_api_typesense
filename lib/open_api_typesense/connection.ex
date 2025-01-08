defmodule OpenApiTypesense.Connection do
  @moduledoc since: "0.2.0"

  @moduledoc """
  Fetches credentials either from application env or map.
  """

  alias OpenApiTypesense.Client

  @derive {Inspect, except: [:api_key]}
  defstruct [:host, :api_key, :port, :scheme, :client]

  @typedoc since: "0.2.0"
  @type t() :: %{
          host: binary() | nil,
          api_key: binary() | nil,
          port: non_neg_integer() | nil,
          scheme: binary() | nil,
          client: list() | nil
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
  def new(connection) when is_map(connection) do
    missing_fields = Enum.sort(required_fields() -- Map.keys(connection))

    if missing_fields == [] do
      struct(__MODULE__, connection)
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
    |> Map.drop([:__struct__])
    |> Map.drop([:client])
    |> Map.keys()
  end

  @spec defaults :: map()
  defp defaults do
    %{
      host: Client.get_host(),
      api_key: Client.api_key(),
      port: Client.get_port(),
      scheme: Client.get_scheme(),
      client: Client.get_client()
    }
  end
end
