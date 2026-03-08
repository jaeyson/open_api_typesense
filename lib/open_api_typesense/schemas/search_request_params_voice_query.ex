defmodule OpenApiTypesense.SearchRequestParamsVoiceQuery do
  @moduledoc """
  Provides struct and type for a SearchRequestParamsVoiceQuery
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{transcribed_query: String.t()}

  defstruct [:transcribed_query]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [transcribed_query: {:string, :generic}]
  end
end
