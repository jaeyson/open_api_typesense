defmodule OpenApiTypesense.SearchRequestParams do
  @moduledoc """
  Provides struct and type for a SearchRequestParams
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          collection_name: String.t(),
          per_page: integer,
          q: String.t(),
          voice_query: OpenApiTypesense.SearchRequestParamsVoiceQuery.t()
        }

  defstruct [:collection_name, :per_page, :q, :voice_query]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      collection_name: :string,
      per_page: :integer,
      q: :string,
      voice_query: {OpenApiTypesense.SearchRequestParamsVoiceQuery, :t}
    ]
  end
end
