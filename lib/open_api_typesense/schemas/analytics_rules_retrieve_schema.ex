defmodule OpenApiTypesense.AnalyticsRulesRetrieveSchema do
  @moduledoc """
  Provides struct and type for a AnalyticsRulesRetrieveSchema
  """

  @type t :: %__MODULE__{rules: [OpenApiTypesense.AnalyticsRuleSchema.t()] | nil}

  defstruct [:rules]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [rules: [{OpenApiTypesense.AnalyticsRuleSchema, :t}]]
  end
end
