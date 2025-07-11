defmodule OpenApiTypesense.FacetCountsStats do
  @moduledoc """
  Provides struct and type for a FacetCountsStats
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          avg: number,
          max: number,
          min: number,
          sum: number,
          total_values: integer
        }

  defstruct [:avg, :max, :min, :sum, :total_values]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [avg: :number, max: :number, min: :number, sum: :number, total_values: :integer]
  end
end
