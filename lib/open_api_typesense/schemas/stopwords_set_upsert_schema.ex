defmodule OpenApiTypesense.StopwordsSetUpsertSchema do
  @moduledoc """
  Provides struct and type for a StopwordsSetUpsertSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{locale: String.t(), stopwords: [String.t()]}

  defstruct [:locale, :stopwords]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [locale: {:string, :generic}, stopwords: [string: :generic]]
  end
end
