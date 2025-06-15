defmodule OpenApiTypesense.Stemming do
  @moduledoc since: "0.7.0"

  @moduledoc """
  Provides API endpoints related to stemming
  """

  defstruct [:dictionaries]

  @default_client OpenApiTypesense.Client

  @doc """
  Retrieve a stemming dictionary

  Fetch details of a specific stemming dictionary.
  """
  @doc since: "0.7.0"
  @spec get_stemming_dictionary(dictionary_id :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.StemmingDictionary.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_stemming_dictionary(dictionary_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [dictionary_id: dictionary_id],
      call: {OpenApiTypesense.Stemming, :get_stemming_dictionary},
      url: "/stemming/dictionaries/#{dictionary_id}",
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

  ## Example
      iex> body = [
      ...>   %{"word" => "people", "root" => "person"}
      ...>   %{"word" => "children", "root" => "child"}
      ...>   %{"word" => "geese", "root" => "goose"}
      ...> ]
      iex> OpenApiTypesense.Stemming.import_stemming_dictionary(body, id: "irregular-plurals")

  """
  @doc since: "0.7.0"
  @spec import_stemming_dictionary(body :: list(map), opts :: keyword) ::
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
      # request: [{"application/json", {:string, :generic}}],
      request: [{"application/octet-stream", {:string, :generic}}],
      response: [
        {200, {:string, :generic}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @type list_stemming_dictionaries_200_json_resp :: %{dictionaries: [String.t()]}

  @doc """
  List all stemming dictionaries

  Retrieve a list of all available stemming dictionaries.
  """
  @doc since: "0.7.0"
  @spec list_stemming_dictionaries(opts :: keyword) ::
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
