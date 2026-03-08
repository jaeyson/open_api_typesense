defmodule OpenApiTypesense.AnalyticsEvent do
  @moduledoc """
  Provides struct and type for a AnalyticsEvent
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          data: OpenApiTypesense.AnalyticsEventData.t(),
          event_type: String.t(),
          name: String.t()
        }

  defstruct [:data, :event_type, :name]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: {OpenApiTypesense.AnalyticsEventData, :t},
      event_type: {:string, :generic},
      name: {:string, :generic}
    ]
  end
end
