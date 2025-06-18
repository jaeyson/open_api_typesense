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

  defimpl(Poison.Decoder, for: OpenApiTypesense.SearchOverride) do
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
