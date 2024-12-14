defmodule OpenApiTypesense.SearchResultHitTextMatchInfo do
  @moduledoc """
  Provides struct and type for a SearchResultHitTextMatchInfo
  """

  @type t :: %__MODULE__{
          best_field_score: String.t() | nil,
          best_field_weight: integer | nil,
          fields_matched: integer | nil,
          num_tokens_dropped: integer | nil,
          score: String.t() | nil,
          tokens_matched: integer | nil,
          typo_prefix_score: integer | nil
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
