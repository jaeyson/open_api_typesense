defmodule OpenApiTypesense.Stopwords do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to stopwords
  """

  defstruct [:id]

  @default_client OpenApiTypesense.Client

  @type delete_stopwords_set_200_json_resp :: %{id: String.t()}

  @doc """
  Delete a stopwords set.

  Permanently deletes a stopwords set, given it's name.
  """
  @doc since: "0.4.0"
  @spec delete_stopwords_set(String.t(), keyword) ::
          {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_stopwords_set(setId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [setId: setId],
      call: {OpenApiTypesense.Stopwords, :delete_stopwords_set},
      url: "/stopwords/#{setId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.Stopwords, :delete_stopwords_set_200_json_resp}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves a stopwords set.

  Retrieve the details of a stopwords set, given it's name.
  """
  @doc since: "0.4.0"
  @spec retrieve_stopwords_set(String.t(), keyword) ::
          {:ok, OpenApiTypesense.StopwordsSetRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_stopwords_set(setId, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [setId: setId],
      call: {OpenApiTypesense.Stopwords, :retrieve_stopwords_set},
      url: "/stopwords/#{setId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.StopwordsSetRetrieveSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves all stopwords sets.

  Retrieve the details of all stopwords sets
  """
  @doc since: "0.4.0"
  @spec retrieve_stopwords_sets(keyword) ::
          {:ok, OpenApiTypesense.StopwordsSetsRetrieveAllSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_stopwords_sets(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Stopwords, :retrieve_stopwords_sets},
      url: "/stopwords",
      method: :get,
      response: [
        {200, {OpenApiTypesense.StopwordsSetsRetrieveAllSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Upserts a stopwords set.

  When an analytics rule is created, we give it a name and describe the type, the source collections and the destination collection.
  """
  @doc since: "0.4.0"
  @spec upsert_stopwords_set(String.t(), OpenApiTypesense.StopwordsSetUpsertSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.StopwordsSetSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_stopwords_set(setId, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [setId: setId, body: body],
      call: {OpenApiTypesense.Stopwords, :upsert_stopwords_set},
      url: "/stopwords/#{setId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.StopwordsSetUpsertSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.StopwordsSetSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
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
