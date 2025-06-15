defmodule OpenApiTypesense.MultiSearchResult do
  @moduledoc """
  Provides struct and type for a MultiSearchResult
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          conversation: OpenApiTypesense.SearchResultConversation.t(),
          results: [OpenApiTypesense.MultiSearchResultItem.t()]
        }

  defstruct [:results, conversation: %OpenApiTypesense.SearchResultConversation{}]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      conversation: {OpenApiTypesense.SearchResultConversation, :t},
      results: [{OpenApiTypesense.MultiSearchResultItem, :t}]
    ]
  end
end
