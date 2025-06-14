defmodule OpenApiTypesense.APIStatsResponse do
  @moduledoc """
  Provides struct and type for a APIStatsResponse
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          delete_latency_ms: number,
          delete_requests_per_second: number,
          import_latency_ms: number,
          import_requests_per_second: number,
          latency_ms: map,
          overloaded_requests_per_second: number,
          pending_write_batches: number,
          requests_per_second: map,
          search_latency_ms: number,
          search_requests_per_second: number,
          total_requests_per_second: number,
          write_latency_ms: number,
          write_requests_per_second: number
        }

  defstruct [
    :delete_latency_ms,
    :delete_requests_per_second,
    :import_latency_ms,
    :import_requests_per_second,
    :latency_ms,
    :overloaded_requests_per_second,
    :pending_write_batches,
    :requests_per_second,
    :search_latency_ms,
    :search_requests_per_second,
    :total_requests_per_second,
    :write_latency_ms,
    :write_requests_per_second
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      delete_latency_ms: :number,
      delete_requests_per_second: :number,
      import_latency_ms: :number,
      import_requests_per_second: :number,
      latency_ms: :map,
      overloaded_requests_per_second: :number,
      pending_write_batches: :number,
      requests_per_second: :map,
      search_latency_ms: :number,
      search_requests_per_second: :number,
      total_requests_per_second: :number,
      write_latency_ms: :number,
      write_requests_per_second: :number
    ]
  end
end
