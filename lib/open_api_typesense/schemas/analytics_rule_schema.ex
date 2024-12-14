defmodule OpenApiTypesense.AnalyticsRuleSchema do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleSchema
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          params: OpenApiTypesense.AnalyticsRuleParameters.t() | nil,
          type: String.t() | nil
        }

  defstruct [:name, :params, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      name: {:string, :generic},
      params: {OpenApiTypesense.AnalyticsRuleParameters, :t},
      type: {:enum, ["popular_queries", "nohits_queries", "counter"]}
    ]
  end
end
