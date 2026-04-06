defmodule OpenApiTypesense.AnalyticsRuleCreate do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleCreate
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          collection: String.t(),
          event_type: String.t(),
          name: String.t(),
          params: map,
          rule_tag: String.t(),
          type: String.t()
        }

  defstruct [:collection, :event_type, :name, :params, :rule_tag, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      collection: :string,
      event_type: :string,
      name: :string,
      params: :map,
      rule_tag: :string,
      type: {:enum, ["popular_queries", "nohits_queries", "counter", "log"]}
    ]
  end
end
