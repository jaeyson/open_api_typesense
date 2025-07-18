defmodule OpenApiTypesense.ConfigSchema do
  @moduledoc """
  Provides struct and type for a ConfigSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{log_slow_requests_time_ms: integer}

  defstruct [:log_slow_requests_time_ms]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [log_slow_requests_time_ms: :integer]
  end
end
