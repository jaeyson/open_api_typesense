defmodule OpenApiTypesense.Stemming do
  @moduledoc since: "0.7.0"

  @moduledoc """
  Provides API endpoints related to stemming
  """

  alias OpenApiTypesense.Connection

  defstruct [:dictionaries]

  @default_client OpenApiTypesense.Client

  @doc """
  Retrieve a stemming dictionary

  Fetch details of a specific stemming dictionary.
  """
  @doc since: "0.7.0"
  @spec get_stemming_dictionary(String.t()) ::
          {:ok, OpenApiTypesense.StemmingDictionary.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_stemming_dictionary(dictionaryId) do
    get_stemming_dictionary(dictionaryId, [])
  end

  @doc """
  Either one of:
  - `get_stemming_dictionary(dictionary_id, opts)`
  - `get_stemming_dictionary(dictionary_id, %{api_key: xyz, host: ...})`
  - `get_stemming_dictionary(dictionary_id, Connection.new())`
  """
  @doc since: "0.7.0"
  @spec get_stemming_dictionary(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.StemmingDictionary.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_stemming_dictionary(dictionaryId, opts) when is_list(opts) do
    get_stemming_dictionary(Connection.new(), dictionaryId, opts)
  end

  def get_stemming_dictionary(conn, dictionaryId) do
    get_stemming_dictionary(conn, dictionaryId, [])
  end

  @doc """
  Either one of:
  - `get_stemming_dictionary(dictionary_id, %{api_key: xyz, host: ...}, opts)`
  - `get_stemming_dictionary(dictionary_id, Connection.new(), opts)`
  """
  @doc since: "0.7.0"
  @spec get_stemming_dictionary(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.StemmingDictionary.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_stemming_dictionary(conn, dictionaryId, opts)
      when not is_struct(conn) and is_map(conn) do
    get_stemming_dictionary(Connection.new(conn), dictionaryId, opts)
  end

  def get_stemming_dictionary(%Connection{} = conn, dictionaryId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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

  ## Example
      iex> body = [
      ...>   %{"word" => "people", "root" => "person"}
      ...>   %{"word" => "children", "root" => "child"}
      ...>   %{"word" => "geese", "root" => "goose"}
      ...> ]
      iex> OpenApiTypesense.Stemming.import_stemming_dictionary(body, id: "irregular-plurals")
  """
  @doc since: "0.7.0"
  @spec import_stemming_dictionary(list(map()), keyword()) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_stemming_dictionary(body, opts) when is_list(opts) do
    import_stemming_dictionary(Connection.new(), body, opts)
  end

  @doc """
  Either one of:
  - `import_stemming_dictionary(%{api_key: xyz, host: ...}, body, id: "something")`
  - `import_stemming_dictionary(dictionary_id, Connection.new(), body, id: "some-id")`
  """
  @doc since: "0.7.0"
  @spec import_stemming_dictionary(map() | Connection.t(), list(map()), keyword()) ::
          {:ok, String.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def import_stemming_dictionary(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    import_stemming_dictionary(Connection.new(conn), body, opts)
  end

  def import_stemming_dictionary(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:id])

    client.request(conn, %{
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

  @type list_stemming_dictionaries_200_json_resp :: %{dictionaries: [String.t()] | nil}

  @doc """
  List all stemming dictionaries

  Retrieve a list of all available stemming dictionaries.
  """
  @doc since: "0.7.0"
  @spec list_stemming_dictionaries ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def list_stemming_dictionaries do
    list_stemming_dictionaries([])
  end

  @doc since: "0.7.0"
  @spec list_stemming_dictionaries(map() | Connection.t() | keyword()) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def list_stemming_dictionaries(opts) when is_list(opts) do
    list_stemming_dictionaries(Connection.new(), opts)
  end

  def list_stemming_dictionaries(conn) do
    list_stemming_dictionaries(conn, [])
  end

  @doc since: "0.7.0"
  @spec list_stemming_dictionaries(map() | Connection.t(), keyword()) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def list_stemming_dictionaries(conn, opts) when not is_struct(conn) and is_map(conn) do
    list_stemming_dictionaries(Connection.new(conn), opts)
  end

  def list_stemming_dictionaries(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
