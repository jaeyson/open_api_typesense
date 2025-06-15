defmodule OpenApiTypesense.Debug do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoint related to debug
  """

  defstruct [:version]

  @default_client OpenApiTypesense.Client

  @type debug_200_json_resp :: %{version: String.t()}

  @doc """
  Print debugging information

  Print debugging information
  """
  @doc since: "0.4.0"
  @spec debug(opts :: keyword) :: {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def debug(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Debug, :debug},
      url: "/debug",
      method: :get,
      response: [
        {200, {OpenApiTypesense.Debug, :debug_200_json_resp}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(:debug_200_json_resp) do
    [version: {:string, :generic}]
  end
end
