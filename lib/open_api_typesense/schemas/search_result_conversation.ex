defmodule OpenApiTypesense.SearchResultConversation do
  @moduledoc """
  Provides struct and type for a SearchResultConversation
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          answer: String.t(),
          conversation_history: [map],
          conversation_id: String.t(),
          query: String.t()
        }

  defstruct [:answer, :conversation_history, :conversation_id, :query]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [answer: :string, conversation_history: [:map], conversation_id: :string, query: :string]
  end
end
