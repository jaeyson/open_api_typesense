defmodule OpenApiTypesense.Connection do
  @moduledoc since: "0.2.0"
  @moduledoc """
  Fetches credentials either from application env or map.
  """
  alias OpenApiTypesense.Client

  @derive {Inspect, except: [:api_key]}
  defstruct [:host, :api_key, :port, :scheme]

  @typedoc since: "0.2.0"
  @type t() :: %{
          host: binary() | nil,
          api_key: binary() | nil,
          port: non_neg_integer() | nil,
          scheme: binary() | nil
        }

  @doc """
  Setting new connection or using the default config.

  > #### On using this function {: .info}
  > Functions e.g. `OpenApiTypesense.Health.health` don't need to explicitly pass this
  > unless you want to use another connection. Also, `api_key` is hidden when invoking
  > this function.

  ## Examples
      iex> alias OpenApiTypesense.Connection
      
      iex> conn = Connection.new()
      %OpenApiTypesense.Connection{
        host: "localhost",
        port: 8108,
        scheme: "http",
        ...
      }
  """
  @doc since: "0.2.0"
  @spec new(connection :: t() | map()) :: %__MODULE__{}
  def new(connection \\ defaults()) when is_map(connection) do
    %__MODULE__{
      host: Map.get(connection, :host),
      api_key: Map.get(connection, :api_key),
      port: Map.get(connection, :port),
      scheme: Map.get(connection, :scheme)
    }
  end

  @doc since: "0.2.0"
  @spec defaults :: map()
  defp defaults do
    %{
      host: Client.get_host(),
      api_key: Client.api_key(),
      port: Client.get_port(),
      scheme: Client.get_scheme()
    }
  end
end
