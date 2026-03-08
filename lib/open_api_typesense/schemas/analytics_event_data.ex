defmodule OpenApiTypesense.AnalyticsEventData do
  @moduledoc """
  Provides struct and type for a AnalyticsEventData
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          analytics_tag: String.t(),
          doc_id: String.t(),
          doc_ids: [String.t()],
          q: String.t(),
          user_id: String.t()
        }

  defstruct [:analytics_tag, :doc_id, :doc_ids, :q, :user_id]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      analytics_tag: {:string, :generic},
      doc_id: {:string, :generic},
      doc_ids: [string: :generic],
      q: {:string, :generic},
      user_id: {:string, :generic}
    ]
  end
end
