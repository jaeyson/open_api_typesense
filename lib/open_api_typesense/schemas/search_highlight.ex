defmodule OpenApiTypesense.SearchHighlight do
  @moduledoc """
  Provides struct and type for a SearchHighlight
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          field: String.t(),
          indices: [integer],
          matched_tokens: [map],
          snippet: String.t(),
          snippets: [String.t()],
          value: String.t(),
          values: [String.t()]
        }

  defstruct [:field, :indices, :matched_tokens, :snippet, :snippets, :value, :values]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      field: {:string, :generic},
      indices: [:integer],
      matched_tokens: [:map],
      snippet: {:string, :generic},
      snippets: [string: :generic],
      value: {:string, :generic},
      values: [string: :generic]
    ]
  end
end
