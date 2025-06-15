defmodule OpenApiTypesense.StemmingDictionary do
  @moduledoc """
  Provides struct and type for a StemmingDictionary
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{id: String.t(), words: [OpenApiTypesense.StemmingDictionaryWords.t()]}

  defstruct [:id, :words]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [id: {:string, :generic}, words: [{OpenApiTypesense.StemmingDictionaryWords, :t}]]
  end
end
