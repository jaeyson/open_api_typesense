defmodule OpenApiTypesense.SearchOverride do
  @moduledoc """
  Provides struct and type for a SearchOverride
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          effective_from_ts: integer,
          effective_to_ts: integer,
          excludes: [OpenApiTypesense.SearchOverrideExclude.t()],
          filter_by: String.t(),
          filter_curated_hits: boolean,
          id: String.t(),
          includes: [OpenApiTypesense.SearchOverrideInclude.t()],
          metadata: map,
          remove_matched_tokens: boolean,
          replace_query: String.t(),
          rule: OpenApiTypesense.SearchOverrideRule.t(),
          sort_by: String.t(),
          stop_processing: boolean
        }

  defstruct [
    :effective_from_ts,
    :effective_to_ts,
    :excludes,
    :filter_by,
    :filter_curated_hits,
    :id,
    :includes,
    :metadata,
    :remove_matched_tokens,
    :replace_query,
    :sort_by,
    :stop_processing,
    rule: %OpenApiTypesense.SearchOverrideRule{}
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      effective_from_ts: :integer,
      effective_to_ts: :integer,
      excludes: [{OpenApiTypesense.SearchOverrideExclude, :t}],
      filter_by: {:string, :generic},
      filter_curated_hits: :boolean,
      id: {:string, :generic},
      includes: [{OpenApiTypesense.SearchOverrideInclude, :t}],
      metadata: :map,
      remove_matched_tokens: :boolean,
      replace_query: {:string, :generic},
      rule: {OpenApiTypesense.SearchOverrideRule, :t},
      sort_by: {:string, :generic},
      stop_processing: :boolean
    ]
  end
end
