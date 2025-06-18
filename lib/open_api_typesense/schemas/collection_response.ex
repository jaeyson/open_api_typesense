defmodule OpenApiTypesense.CollectionResponse do
  @moduledoc """
  Provides struct and type for a CollectionResponse
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          created_at: integer,
          default_sorting_field: String.t(),
          enable_nested_fields: boolean,
          fields: [OpenApiTypesense.Field.t()],
          name: String.t(),
          num_documents: integer,
          symbols_to_index: [String.t()],
          token_separators: [String.t()],
          voice_query_model: OpenApiTypesense.VoiceQueryModelCollectionConfig.t()
        }

  defstruct [
    :created_at,
    :fields,
    :name,
    :num_documents,
    default_sorting_field: "",
    enable_nested_fields: false,
    symbols_to_index: [],
    token_separators: [],
    voice_query_model: %OpenApiTypesense.VoiceQueryModelCollectionConfig{}
  ]

  defimpl(Poison.Decoder, for: OpenApiTypesense.CollectionResponse) do
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
      created_at: :integer,
      default_sorting_field: {:string, :generic},
      enable_nested_fields: :boolean,
      fields: [{OpenApiTypesense.Field, :t}],
      name: {:string, :generic},
      num_documents: :integer,
      symbols_to_index: [string: :generic],
      token_separators: [string: :generic],
      voice_query_model: {OpenApiTypesense.VoiceQueryModelCollectionConfig, :t}
    ]
  end
end
