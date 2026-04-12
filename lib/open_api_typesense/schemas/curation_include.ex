defmodule OpenApiTypesense.CurationInclude do
  @moduledoc """
  Provides struct and type for a CurationInclude
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{id: String.t(), position: integer}

  defstruct [:id, :position]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [id: :string, position: :integer]
  end
end
