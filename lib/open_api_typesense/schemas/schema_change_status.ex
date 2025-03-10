defmodule OpenApiTypesense.SchemaChangeStatus do
  @moduledoc """
  Provides struct and type for a SchemaChangeStatus
  """

  @type t :: %__MODULE__{
          altered_docs: integer | nil,
          collection: String.t() | nil,
          validated_docs: integer | nil
        }

  defstruct [:altered_docs, :collection, :validated_docs]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [altered_docs: :integer, collection: {:string, :generic}, validated_docs: :integer]
  end
end
