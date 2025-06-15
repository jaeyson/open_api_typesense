defmodule OpenApiTypesense.FacetCountsCounts do
  @moduledoc """
  Provides struct and type for a FacetCountsCounts
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{count: integer, highlighted: String.t(), parent: map, value: String.t()}

  defstruct [:count, :highlighted, :parent, :value]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [count: :integer, highlighted: {:string, :generic}, parent: :map, value: {:string, :generic}]
  end
end
