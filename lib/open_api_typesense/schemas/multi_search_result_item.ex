defmodule OpenApiTypesense.MultiSearchResultItem do
  @moduledoc """
  Provides struct and type for a MultiSearchResultItem
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          code: integer,
          conversation: OpenApiTypesense.SearchResultConversation.t(),
          error: String.t(),
          facet_counts: [OpenApiTypesense.FacetCounts.t()],
          found: integer,
          found_docs: integer,
          grouped_hits: [OpenApiTypesense.SearchGroupedHit.t()],
          hits: [OpenApiTypesense.SearchResultHit.t()],
          out_of: integer,
          page: integer,
          request_params: map,
          search_cutoff: boolean,
          search_time_ms: integer
        }

  defstruct [
    :code,
    :error,
    :facet_counts,
    :found,
    :found_docs,
    :grouped_hits,
    :hits,
    :out_of,
    :page,
    :request_params,
    :search_cutoff,
    :search_time_ms,
    conversation: %OpenApiTypesense.SearchResultConversation{}
  ]

  defimpl(Poison.Decoder, for: OpenApiTypesense.MultiSearchResultItem) do
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
      code: :integer,
      conversation: {OpenApiTypesense.SearchResultConversation, :t},
      error: {:string, :generic},
      facet_counts: [{OpenApiTypesense.FacetCounts, :t}],
      found: :integer,
      found_docs: :integer,
      grouped_hits: [{OpenApiTypesense.SearchGroupedHit, :t}],
      hits: [{OpenApiTypesense.SearchResultHit, :t}],
      out_of: :integer,
      page: :integer,
      request_params: :map,
      search_cutoff: :boolean,
      search_time_ms: :integer
    ]
  end
end
