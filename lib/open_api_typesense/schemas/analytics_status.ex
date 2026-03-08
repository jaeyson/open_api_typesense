defmodule OpenApiTypesense.AnalyticsStatus do
  @moduledoc """
  Provides struct and type for a AnalyticsStatus
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          doc_counter_events: integer,
          doc_log_events: integer,
          log_prefix_queries: integer,
          nohits_prefix_queries: integer,
          popular_prefix_queries: integer,
          query_counter_events: integer,
          query_log_events: integer
        }

  defstruct [
    :doc_counter_events,
    :doc_log_events,
    :log_prefix_queries,
    :nohits_prefix_queries,
    :popular_prefix_queries,
    :query_counter_events,
    :query_log_events
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      doc_counter_events: :integer,
      doc_log_events: :integer,
      log_prefix_queries: :integer,
      nohits_prefix_queries: :integer,
      popular_prefix_queries: :integer,
      query_counter_events: :integer,
      query_log_events: :integer
    ]
  end
end
