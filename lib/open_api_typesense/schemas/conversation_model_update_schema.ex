defmodule OpenApiTypesense.ConversationModelUpdateSchema do
  @moduledoc """
  Provides struct and type for a ConversationModelUpdateSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          account_id: String.t(),
          api_key: String.t(),
          history_collection: String.t(),
          id: String.t(),
          max_bytes: integer,
          model_name: String.t(),
          system_prompt: String.t(),
          ttl: integer,
          vllm_url: String.t()
        }

  defstruct [
    :account_id,
    :api_key,
    :history_collection,
    :id,
    :max_bytes,
    :model_name,
    :system_prompt,
    :ttl,
    :vllm_url
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      account_id: {:string, :generic},
      api_key: {:string, :generic},
      history_collection: {:string, :generic},
      id: {:string, :generic},
      max_bytes: :integer,
      model_name: {:string, :generic},
      system_prompt: {:string, :generic},
      ttl: :integer,
      vllm_url: {:string, :generic}
    ]
  end
end
