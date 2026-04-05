defmodule OpenApiTypesense.NLSearchModelCreateSchema do
  @moduledoc """
  Provides struct and type for a NLSearchModelCreateSchema
  """
  use OpenApiTypesense.Encoder

  @type t :: %__MODULE__{
          access_token: String.t(),
          account_id: String.t(),
          api_key: String.t(),
          api_url: String.t(),
          api_version: String.t(),
          client_id: String.t(),
          client_secret: String.t(),
          id: String.t(),
          max_bytes: integer,
          max_output_tokens: integer,
          model_name: String.t(),
          project_id: String.t(),
          refresh_token: String.t(),
          region: String.t(),
          stop_sequences: [String.t()],
          system_prompt: String.t(),
          temperature: number,
          top_k: integer,
          top_p: number
        }

  defstruct [
    :access_token,
    :account_id,
    :api_key,
    :api_url,
    :api_version,
    :client_id,
    :client_secret,
    :id,
    :max_bytes,
    :max_output_tokens,
    :model_name,
    :project_id,
    :refresh_token,
    :region,
    :stop_sequences,
    :system_prompt,
    :temperature,
    :top_k,
    :top_p
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      access_token: :string,
      account_id: :string,
      api_key: :string,
      api_url: :string,
      api_version: :string,
      client_id: :string,
      client_secret: :string,
      id: :string,
      max_bytes: :integer,
      max_output_tokens: :integer,
      model_name: :string,
      project_id: :string,
      refresh_token: :string,
      region: :string,
      stop_sequences: [:string],
      system_prompt: :string,
      temperature: :number,
      top_k: :integer,
      top_p: :number
    ]
  end
end
