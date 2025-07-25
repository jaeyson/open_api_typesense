defmodule OpenApiTypesense.ApiKey do
  @moduledoc """
  Provides struct and type for a ApiKey
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          actions: [String.t()],
          collections: [String.t()],
          description: String.t(),
          expires_at: integer,
          id: integer,
          value: String.t(),
          value_prefix: String.t()
        }

  defstruct [:actions, :collections, :description, :expires_at, :id, :value, :value_prefix]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      actions: [string: :generic],
      collections: [string: :generic],
      description: {:string, :generic},
      expires_at: :integer,
      id: :integer,
      value: {:string, :generic},
      value_prefix: {:string, :generic}
    ]
  end
end
