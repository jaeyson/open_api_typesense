defmodule OpenApiTypesense.SearchResultHitDocument do
  @moduledoc """
  Provides struct and type for a SearchResultHitDocument
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{}

  defstruct []

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    []
  end
end
