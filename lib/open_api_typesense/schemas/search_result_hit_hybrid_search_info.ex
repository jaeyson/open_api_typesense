defmodule OpenApiTypesense.SearchResultHitHybridSearchInfo do
  @moduledoc """
  Provides struct and type for a SearchResultHitHybridSearchInfo
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{rank_fusion_score: number}

  defstruct [:rank_fusion_score]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [rank_fusion_score: :number]
  end
end
