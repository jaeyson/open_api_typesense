defmodule OpenApiTypesense.SearchResultHit do
  @moduledoc """
  Provides struct and type for a SearchResultHit
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          document: OpenApiTypesense.SearchResultHitDocument.t(),
          geo_distance_meters: OpenApiTypesense.SearchResultHitGeoDistanceMeters.t(),
          highlight: map,
          highlights: [OpenApiTypesense.SearchHighlight.t()],
          text_match: integer,
          text_match_info: OpenApiTypesense.SearchResultHitTextMatchInfo.t(),
          vector_distance: number
        }

  defstruct [
    :document,
    :geo_distance_meters,
    :highlight,
    :highlights,
    :text_match,
    :text_match_info,
    :vector_distance
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      document: {OpenApiTypesense.SearchResultHitDocument, :t},
      geo_distance_meters: {OpenApiTypesense.SearchResultHitGeoDistanceMeters, :t},
      highlight: :map,
      highlights: [{OpenApiTypesense.SearchHighlight, :t}],
      text_match: :integer,
      text_match_info: {OpenApiTypesense.SearchResultHitTextMatchInfo, :t},
      vector_distance: :number
    ]
  end
end
