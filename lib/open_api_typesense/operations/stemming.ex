defmodule OpenApiTypesense.Stemming do
  @moduledoc """
  Provides API endpoints related to stemming
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Retrieve a stemming dictionary

  Fetch details of a specific stemming dictionary.
  """
  @spec get_stemming_dictionary(String.t(), keyword) ::
          {:ok, OpenApiTypesense.StemmingDictionary.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_stemming_dictionary(dictionaryId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [dictionaryId: dictionaryId],
      call: {OpenApiTypesense.Stemming, :get_stemming_dictionary},
      url: "/stemming/dictionaries/#{dictionaryId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.StemmingDictionary, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Import a stemming dictionary

  Upload a JSONL file containing word mappings to create or update a stemming dictionary.

  ## Options

    * `id`: The ID to assign to the dictionary

  """
  @spec import_stemming_dictionary(String.t(), keyword) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_stemming_dictionary(body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:id])

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Stemming, :import_stemming_dictionary},
      url: "/stemming/dictionaries/import",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", {:string, :generic}}],
      response: [
        {200, {:string, :generic}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @type list_stemming_dictionaries_200_json_resp :: %{dictionaries: [String.t()] | nil}

  @doc """
  List all stemming dictionaries

  Retrieve a list of all available stemming dictionaries.
  """
  @spec list_stemming_dictionaries(keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def list_stemming_dictionaries(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Stemming, :list_stemming_dictionaries},
      url: "/stemming/dictionaries",
      method: :get,
      response: [
        {200, {OpenApiTypesense.Stemming, :list_stemming_dictionaries_200_json_resp}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(:list_stemming_dictionaries_200_json_resp) do
    [dictionaries: [string: :generic]]
  end
end
