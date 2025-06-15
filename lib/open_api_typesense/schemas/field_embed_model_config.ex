defmodule OpenApiTypesense.FieldEmbedModelConfig do
  @moduledoc """
  Provides struct and type for a FieldEmbedModelConfig
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          access_token: String.t(),
          api_key: String.t(),
          client_id: String.t(),
          client_secret: String.t(),
          indexing_prefix: String.t(),
          model_name: String.t(),
          project_id: String.t(),
          query_prefix: String.t(),
          refresh_token: String.t(),
          url: String.t()
        }

  defstruct [
    :access_token,
    :api_key,
    :client_id,
    :client_secret,
    :indexing_prefix,
    :model_name,
    :project_id,
    :query_prefix,
    :refresh_token,
    :url
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      access_token: {:string, :generic},
      api_key: {:string, :generic},
      client_id: {:string, :generic},
      client_secret: {:string, :generic},
      indexing_prefix: {:string, :generic},
      model_name: {:string, :generic},
      project_id: {:string, :generic},
      query_prefix: {:string, :generic},
      refresh_token: {:string, :generic},
      url: {:string, :generic}
    ]
  end
end
