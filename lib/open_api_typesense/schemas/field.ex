defmodule OpenApiTypesense.Field do
  @moduledoc """
  Provides struct and type for a Field
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          drop: boolean,
          embed: OpenApiTypesense.FieldEmbed.t(),
          facet: boolean,
          index: boolean,
          infix: boolean,
          locale: String.t(),
          name: String.t(),
          num_dim: integer,
          optional: boolean,
          range_index: boolean,
          reference: String.t(),
          sort: boolean,
          stem: boolean,
          stem_dictionary: String.t(),
          store: boolean,
          symbols_to_index: [String.t()],
          token_separators: [String.t()],
          type: String.t(),
          vec_dist: String.t()
        }

  defstruct [
    :drop,
    :embed,
    :facet,
    :locale,
    :name,
    :num_dim,
    :optional,
    :range_index,
    :reference,
    :sort,
    :stem,
    :stem_dictionary,
    :store,
    :type,
    :vec_dist,
    index: true,
    infix: false,
    symbols_to_index: [],
    token_separators: []
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      drop: :boolean,
      embed: {OpenApiTypesense.FieldEmbed, :t},
      facet: :boolean,
      index: :boolean,
      infix: :boolean,
      locale: {:string, :generic},
      name: {:string, :generic},
      num_dim: :integer,
      optional: :boolean,
      range_index: :boolean,
      reference: {:string, :generic},
      sort: :boolean,
      stem: :boolean,
      stem_dictionary: {:string, :generic},
      store: :boolean,
      symbols_to_index: [string: :generic],
      token_separators: [string: :generic],
      type: {:string, :generic},
      vec_dist: {:string, :generic}
    ]
  end
end
