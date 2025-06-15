defmodule OpenApiTypesense.AnalyticsRuleUpsertSchema do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleUpsertSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{params: OpenApiTypesense.AnalyticsRuleParameters.t(), type: String.t()}

  defstruct [:type, params: %OpenApiTypesense.AnalyticsRuleParameters{}]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      params: {OpenApiTypesense.AnalyticsRuleParameters, :t},
      type: {:enum, ["popular_queries", "nohits_queries", "counter"]}
    ]
  end
end
