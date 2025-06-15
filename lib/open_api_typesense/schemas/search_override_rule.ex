defmodule OpenApiTypesense.SearchOverrideRule do
  @moduledoc """
  Provides struct and type for a SearchOverrideRule
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          filter_by: String.t(),
          match: String.t(),
          query: String.t(),
          tags: [String.t()]
        }

  defstruct [:filter_by, :match, :query, :tags]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      filter_by: {:string, :generic},
      match: {:enum, ["exact", "contains"]},
      query: {:string, :generic},
      tags: [string: :generic]
    ]
  end
end
