defmodule OpenApiTypesense.SearchResultRequestParams do
  @moduledoc """
  Provides struct and type for a SearchResultRequestParams
  """

  @type t :: %__MODULE__{
          collection_name: String.t(),
          per_page: integer,
          q: String.t(),
          voice_query: OpenApiTypesense.SearchResultRequestParamsVoiceQuery.t() | nil
        }

  defstruct [:collection_name, :per_page, :q, :voice_query]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      collection_name: {:string, :generic},
      per_page: :integer,
      q: {:string, :generic},
      voice_query: {OpenApiTypesense.SearchResultRequestParamsVoiceQuery, :t}
    ]
  end
end
