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

  defimpl(Poison.Decoder, for: OpenApiTypesense.FacetCounts) do
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
      counts: [{OpenApiTypesense.FacetCountsCounts, :t}],
      field_name: {:string, :generic},
      stats: {OpenApiTypesense.FacetCountsStats, :t}
    ]
  end
end
