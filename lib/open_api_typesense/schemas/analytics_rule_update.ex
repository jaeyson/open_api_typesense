defmodule OpenApiTypesense.AnalyticsRuleUpdate do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleUpdate
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          params: OpenApiTypesense.AnalyticsRuleUpdateParams.t(),
          rule_tag: String.t()
        }

  defstruct [:name, :params, :rule_tag]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [name: :string, params: {OpenApiTypesense.AnalyticsRuleUpdateParams, :t}, rule_tag: :string]
  end
end
