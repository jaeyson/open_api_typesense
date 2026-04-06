defmodule OpenApiTypesense.AnalyticsRuleUpdateParams do
  @moduledoc """
  Provides struct and type for a AnalyticsRuleUpdateParams
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          capture_search_requests: boolean,
          counter_field: String.t(),
          destination_collection: String.t(),
          expand_query: boolean,
          limit: integer,
          meta_fields: [String.t()],
          weight: integer
        }

  defstruct [
    :capture_search_requests,
    :counter_field,
    :destination_collection,
    :expand_query,
    :limit,
    :meta_fields,
    :weight
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      capture_search_requests: :boolean,
      counter_field: :string,
      destination_collection: :string,
      expand_query: :boolean,
      limit: :integer,
      meta_fields: [:string],
      weight: :integer
    ]
  end
end
