defmodule OpenApiTypesense.MultiSearchSearchesParameter do
  @moduledoc """
  Provides struct and type for a MultiSearchSearchesParameter
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          searches: [OpenApiTypesense.MultiSearchCollectionParameters.t()],
          union: boolean
        }

  defstruct [:searches, :union]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [searches: [{OpenApiTypesense.MultiSearchCollectionParameters, :t}], union: :boolean]
  end
end
