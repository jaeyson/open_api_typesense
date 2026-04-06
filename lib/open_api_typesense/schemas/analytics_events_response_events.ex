defmodule OpenApiTypesense.AnalyticsEventsResponseEvents do
  @moduledoc """
  Provides struct and type for a AnalyticsEventsResponseEvents
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          collection: String.t(),
          doc_id: String.t(),
          doc_ids: [String.t()],
          event_type: String.t(),
          name: String.t(),
          query: String.t(),
          timestamp: integer,
          user_id: String.t()
        }

  defstruct [:collection, :doc_id, :doc_ids, :event_type, :name, :query, :timestamp, :user_id]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      collection: :string,
      doc_id: :string,
      doc_ids: [:string],
      event_type: :string,
      name: :string,
      query: :string,
      timestamp: {:integer, "int64"},
      user_id: :string
    ]
  end
end
