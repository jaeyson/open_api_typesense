defmodule OpenApiTypesense.DropTokensMode do
  @moduledoc """
  Provides struct and type for a DropTokensMode
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{match: String.t()}

  defstruct [:match]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [match: {:enum, ["right_to_left", "left_to_right", "both_sides:3"]}]
  end
end
