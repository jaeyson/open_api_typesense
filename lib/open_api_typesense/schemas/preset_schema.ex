defmodule OpenApiTypesense.PresetSchema do
  @moduledoc """
  Provides struct and type for a PresetSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          value:
            OpenApiTypesense.MultiSearchSearchesParameter.t()
            | OpenApiTypesense.SearchParameters.t()
        }

  defstruct [:name, :value]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      name: {:string, :generic},
      value:
        {:union,
         [
           {OpenApiTypesense.MultiSearchSearchesParameter, :t},
           {OpenApiTypesense.SearchParameters, :t}
         ]}
    ]
  end
end
