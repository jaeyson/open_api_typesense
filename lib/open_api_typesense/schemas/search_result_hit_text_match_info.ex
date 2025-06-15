defmodule OpenApiTypesense.SearchResultHitTextMatchInfo do
  @moduledoc """
  Provides struct and type for a SearchResultHitTextMatchInfo
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          best_field_score: String.t(),
          best_field_weight: integer,
          fields_matched: integer,
          num_tokens_dropped: integer,
          score: String.t(),
          tokens_matched: integer,
          typo_prefix_score: integer
        }

  defstruct [
    :best_field_score,
    :best_field_weight,
    :fields_matched,
    :num_tokens_dropped,
    :score,
    :tokens_matched,
    :typo_prefix_score
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      best_field_score: {:string, :generic},
      best_field_weight: :integer,
      fields_matched: :integer,
      num_tokens_dropped: :integer,
      score: {:string, :generic},
      tokens_matched: :integer,
      typo_prefix_score: :integer
    ]
  end
end
