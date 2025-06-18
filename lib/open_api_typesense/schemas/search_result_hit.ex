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

  defimpl(Poison.Decoder, for: OpenApiTypesense.SearchResultHit) do
    def decode(value, %{as: struct}) do
      mod =
        case struct do
          [m] -> m
          m -> m
        end

      filtered_type =
        mod.__struct__.__fields__()
        |> Enum.filter(fn {_field, v} ->
          case v do
            [{mod, :t}] when is_atom(mod) -> true
            _ -> false
          end
        end)

      case filtered_type do
        [{_key, [{module, :t}]} | _rest] = list when is_list(list) and is_atom(module) ->
          Enum.reduce(list, value, fn {key, [{mod, :t}]}, acc ->
            Map.update!(acc, key, fn data ->
              body = OpenApiTypesense.Converter.to_atom_keys(data || [], safe: false)

              case body do
                [] -> []
                _ -> Enum.map(body, &struct(mod, &1))
              end
            end)
          end)

        [] ->
          value
      end
    end
  end

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
