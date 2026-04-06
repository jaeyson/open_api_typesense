defmodule OpenApiTypesense.ConversationModelCreateSchema do
  @moduledoc """
  Provides struct and type for a ConversationModelCreateSchema
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
      account_id: :string,
      api_key: :string,
      history_collection: :string,
      id: :string,
      max_bytes: :integer,
      model_name: :string,
      system_prompt: :string,
      ttl: :integer,
      vllm_url: :string
    ]
  end
end
