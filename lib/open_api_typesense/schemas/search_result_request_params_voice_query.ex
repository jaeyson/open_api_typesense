defmodule OpenApiTypesense.SearchResultRequestParamsVoiceQuery do
  @moduledoc """
  Provides struct and type for a SearchResultRequestParamsVoiceQuery
  """

  @type t :: %__MODULE__{transcribed_query: String.t() | nil}

  defstruct [:transcribed_query]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [transcribed_query: {:string, :generic}]
  end
end
