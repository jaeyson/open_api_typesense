defmodule OpenApiTypesense.Stopwords do
  @moduledoc """
  Provides API endpoints related to stopwords
  """

  defstruct [:id]

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @type delete_stopwords_set_200_json_resp :: %{id: String.t()}

  @doc """
  Delete a stopwords set.

  Permanently deletes a stopwords set, given it's name.
  """
  @spec delete_stopwords_set(Connection.t(), String.t(), keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_stopwords_set(conn \\ Connection.new(), setId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [setId: setId],
      call: {OpenApiTypesense.Stopwords, :delete_stopwords_set},
      url: "/stopwords/#{setId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.Stopwords, :delete_stopwords_set_200_json_resp}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves a stopwords set.

  Retrieve the details of a stopwords set, given it's name.
  """
  @spec retrieve_stopwords_set(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.StopwordsSetRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_stopwords_set(conn \\ Connection.new(), setId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [setId: setId],
      call: {OpenApiTypesense.Stopwords, :retrieve_stopwords_set},
      url: "/stopwords/#{setId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.StopwordsSetRetrieveSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves all stopwords sets.

  Retrieve the details of all stopwords sets
  """
  @spec retrieve_stopwords_sets(Connection.t(), keyword) ::
          {:ok, OpenApiTypesense.StopwordsSetsRetrieveAllSchema.t()} | :error
  def retrieve_stopwords_sets(conn \\ Connection.new(), opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Stopwords, :retrieve_stopwords_sets},
      url: "/stopwords",
      method: :get,
      response: [{200, {OpenApiTypesense.StopwordsSetsRetrieveAllSchema, :t}}],
      opts: opts
    })
  end

  @doc """
  Upserts a stopwords set.

  When an analytics rule is created, we give it a name and describe the type, the source collections and the destination collection.
  """
  @spec upsert_stopwords_set(
          Connection.t(),
          String.t(),
          OpenApiTypesense.StopwordsSetUpsertSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.StopwordsSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_stopwords_set(conn \\ Connection.new(), setId, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [setId: setId, body: body],
      call: {OpenApiTypesense.Stopwords, :upsert_stopwords_set},
      url: "/stopwords/#{setId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.StopwordsSetUpsertSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.StopwordsSetSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(:delete_stopwords_set_200_json_resp) do
    [id: {:string, :generic}]
  end
end