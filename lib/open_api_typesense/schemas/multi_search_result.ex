defmodule OpenApiTypesense.MultiSearchResult do
  @moduledoc """
  Provides struct and type for a MultiSearchResult
  """

  @type t :: %__MODULE__{
          conversation: OpenApiTypesense.SearchResultConversation.t() | nil,
          results: [OpenApiTypesense.SearchResult.t()]
        }

  defstruct [:conversation, :results]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      conversation: {OpenApiTypesense.SearchResultConversation, :t},
      results: [{OpenApiTypesense.SearchResult, :t}]
    ]
  end
end
