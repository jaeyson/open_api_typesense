defmodule OpenApiTypesense.VoiceQueryModelCollectionConfig do
  @moduledoc """
  Provides struct and type for a VoiceQueryModelCollectionConfig
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{model_name: String.t()}

  defstruct model_name: ""

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [model_name: {:string, :generic}]
  end
end
