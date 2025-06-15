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
