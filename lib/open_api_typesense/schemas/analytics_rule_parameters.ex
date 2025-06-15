defmodule OpenApiTypesense.AnalyticsRuleParameters do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleParameters
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          destination: OpenApiTypesense.AnalyticsRuleParametersDestination.t(),
          expand_query: boolean,
          limit: integer,
          source: OpenApiTypesense.AnalyticsRuleParametersSource.t()
        }

  defstruct [
    :expand_query,
    :limit,
    destination: %OpenApiTypesense.AnalyticsRuleParametersDestination{},
    source: %OpenApiTypesense.AnalyticsRuleParametersSource{}
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      destination: {OpenApiTypesense.AnalyticsRuleParametersDestination, :t},
      expand_query: :boolean,
      limit: :integer,
      source: {OpenApiTypesense.AnalyticsRuleParametersSource, :t}
    ]
  end
end
