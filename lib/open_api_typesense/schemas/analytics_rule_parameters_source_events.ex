defmodule OpenApiTypesense.AnalyticsRuleParametersSourceEvents do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleParametersSourceEvents
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{name: String.t(), type: String.t(), weight: number}

  defstruct [:name, :type, :weight]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [name: {:string, :generic}, type: {:string, :generic}, weight: :number]
  end
end
