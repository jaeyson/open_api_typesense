defmodule OpenApiTypesense.StopwordsSetRetrieveSchema do
  @moduledoc """
  Provides struct and type for a StopwordsSetRetrieveSchema
  """

  @type t :: %__MODULE__{stopwords: OpenApiTypesense.StopwordsSetSchema.t()}

  defstruct [:stopwords]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [stopwords: {OpenApiTypesense.StopwordsSetSchema, :t}]
  end
end
