defmodule OpenApiTypesense.SearchSynonym do
  @moduledoc """
  Provides struct and type for a SearchSynonym
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          locale: String.t(),
          root: String.t(),
          symbols_to_index: [String.t()],
          synonyms: [String.t()]
        }

  defstruct [:id, :locale, :root, :symbols_to_index, :synonyms]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: {:string, :generic},
      locale: {:string, :generic},
      root: {:string, :generic},
      symbols_to_index: [string: :generic],
      synonyms: [string: :generic]
    ]
  end
end
