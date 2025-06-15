defmodule OpenApiTypesense.StemmingDictionaryWords do
  @moduledoc """
  Provides struct and type for a StemmingDictionaryWords
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{root: String.t(), word: String.t()}

  defstruct [:root, :word]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [root: {:string, :generic}, word: {:string, :generic}]
  end
end
