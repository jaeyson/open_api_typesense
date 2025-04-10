defmodule OpenApiTypesense.CollectionResponse do
  @moduledoc """
  Provides struct and type for a CollectionResponse
  """

  @type t :: %__MODULE__{
          created_at: integer | nil,
          default_sorting_field: String.t() | nil,
          enable_nested_fields: boolean | nil,
          fields: [OpenApiTypesense.Field.t()] | nil,
          name: String.t() | nil,
          num_documents: integer | nil,
          symbols_to_index: [String.t()] | nil,
          token_separators: [String.t()] | nil,
          voice_query_model: OpenApiTypesense.VoiceQueryModelCollectionConfig.t() | nil
        }

  defstruct [
    :created_at,
    :default_sorting_field,
    :enable_nested_fields,
    :fields,
    :name,
    :num_documents,
    :symbols_to_index,
    :token_separators,
    :voice_query_model
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
