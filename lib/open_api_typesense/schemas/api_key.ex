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
      actions: [:string],
      collections: [:string],
      description: :string,
      expires_at: {:integer, "int64"},
      id: {:integer, "int64"},
      value: :string,
      value_prefix: :string
    ]
  end
end
