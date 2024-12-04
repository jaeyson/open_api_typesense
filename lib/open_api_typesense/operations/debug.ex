defmodule OpenApiTypesense.Debug do
  @moduledoc """
  Provides API endpoint related to debug
  """

  defstruct [:version]

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @type debug_200_json_resp :: %{version: String.t() | nil}

  @doc """
  Print debugging information

  Print debugging information
  """
  @spec debug(Connection.t(), keyword) :: {:ok, map} | :error
  def debug(conn \\ Connection.new(), opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Debug, :debug},
      url: "/debug",
      method: :get,
      response: [{200, {OpenApiTypesense.Debug, :debug_200_json_resp}}],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(:debug_200_json_resp) do
    [version: {:string, :generic}]
  end
end
