defmodule OpenApiTypesense.StopwordsSetSchema do
  @moduledoc """
  Provides struct and type for a StopwordsSetSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{id: String.t(), locale: String.t(), stopwords: [String.t()]}

  defstruct [:id, :locale, :stopwords]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [id: {:string, :generic}, locale: {:string, :generic}, stopwords: [string: :generic]]
  end
end
