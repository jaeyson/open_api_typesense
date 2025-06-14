defmodule OpenApiTypesense.SearchGroupedHit do
  @moduledoc """
  Provides struct and type for a SearchGroupedHit
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          found: integer,
          group_key: [map],
          hits: [OpenApiTypesense.SearchResultHit.t()]
        }

  defstruct [:found, :group_key, :hits]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [found: :integer, group_key: [:map], hits: [{OpenApiTypesense.SearchResultHit, :t}]]
  end
end
