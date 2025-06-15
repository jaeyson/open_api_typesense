defmodule OpenApiTypesense.AnalyticsRuleParametersDestination do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleParametersDestination
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{collection: String.t(), counter_field: String.t()}

  defstruct [:collection, :counter_field]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [collection: {:string, :generic}, counter_field: {:string, :generic}]
  end
end
