defmodule OpenApiTypesense.FacetCounts do
  @moduledoc """
  Provides struct and type for a FacetCounts
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          counts: [OpenApiTypesense.FacetCountsCounts.t()],
          field_name: String.t(),
          stats: OpenApiTypesense.FacetCountsStats.t()
        }

  defstruct [:counts, :field_name, :stats]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      counts: [{OpenApiTypesense.FacetCountsCounts, :t}],
      field_name: {:string, :generic},
      stats: {OpenApiTypesense.FacetCountsStats, :t}
    ]
  end
end
