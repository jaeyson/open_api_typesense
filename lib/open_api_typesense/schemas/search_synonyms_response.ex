defmodule OpenApiTypesense.SearchSynonymsResponse do
  @moduledoc """
  Provides struct and type for a SearchSynonymsResponse
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{synonyms: [OpenApiTypesense.SearchSynonym.t()]}

  defstruct [:synonyms]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [synonyms: [{OpenApiTypesense.SearchSynonym, :t}]]
  end
end
