defmodule OpenApiTypesense.AnalyticsEventCreateSchema do
  @moduledoc """
  Provides struct and type for a AnalyticsEventCreateSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{data: map, name: String.t(), type: String.t()}

  defstruct [:data, :name, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: :map, name: {:string, :generic}, type: {:string, :generic}]
  end
end
