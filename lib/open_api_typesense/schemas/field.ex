defmodule OpenApiTypesense.Field do
  @moduledoc """
  Provides struct and type for a Field
  """

  @type t :: %__MODULE__{
          drop: boolean | nil,
          embed: OpenApiTypesense.FieldEmbed.t() | nil,
          facet: boolean | nil,
          index: boolean | nil,
          infix: boolean | nil,
          locale: String.t() | nil,
          name: String.t(),
          num_dim: integer | nil,
          optional: boolean | nil,
          range_index: boolean | nil,
          reference: String.t() | nil,
          sort: boolean | nil,
          stem: boolean | nil,
          store: boolean | nil,
          type: String.t(),
          vec_dist: String.t() | nil
        }

  defstruct [
    :drop,
    :embed,
    :facet,
    :index,
    :infix,
    :locale,
    :name,
    :num_dim,
    :optional,
    :range_index,
    :reference,
    :sort,
    :stem,
    :store,
    :type,
    :vec_dist
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
      store: :boolean,
      type: {:string, :generic},
      vec_dist: {:string, :generic}
    ]
  end
end
