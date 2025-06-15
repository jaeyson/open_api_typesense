defmodule OpenApiTypesense.ApiKeySchema do
  @moduledoc """
  Provides struct and type for a ApiKeySchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          actions: [String.t()],
          collections: [String.t()],
          description: String.t(),
          expires_at: integer,
          value: String.t()
        }

  defstruct [:actions, :collections, :description, :expires_at, :value]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      actions: [string: :generic],
      collections: [string: :generic],
      description: {:string, :generic},
      expires_at: :integer,
      value: {:string, :generic}
    ]
  end
end
