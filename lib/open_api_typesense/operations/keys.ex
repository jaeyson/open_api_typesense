defmodule OpenApiTypesense.Keys do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to keys
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Create an API Key

  Create an API Key with fine-grain access control. You can restrict access on both a per-collection and per-action level. The generated key is returned only during creation. You want to store this key carefully in a secure place.
  """
  @doc since: "0.4.0"
  @spec create_key(map()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_key(body) do
    create_key(body, [])
  end

  @doc """
  Either one of:
  - `create_key(payload, opts)`
  - `create_key(%{api_key: xyz, host: ...}, payload)`
  - `create_key(Connection.new(), payload)`
  """
  @doc since: "0.4.0"
  @spec create_key(map() | Connection.t(), map() | keyword()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_key(body, opts) when is_list(opts) do
    create_key(Connection.new(), body, opts)
  end

  def create_key(conn, body) do
    create_key(conn, body, [])
  end

  @doc """
  Either one of:
  - `create_key(%{api_key: xyz, host: ...}, payload, opts)`
  - `create_key(Connection.new(), payload, opts)`
  """
  @doc since: "0.4.0"
  @spec create_key(map() | Connection.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_key(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    create_key(Connection.new(conn), body, opts)
  end

  def create_key(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [body: body],
      call: {OpenApiTypesense.Keys, :create_key},
      url: "/keys",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.ApiKeySchema, :t}}],
      response: [
        {201, {OpenApiTypesense.ApiKey, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an API key given its ID.
  """
  @doc since: "0.4.0"
  @spec delete_key(integer()) ::
          {:ok, OpenApiTypesense.ApiKeyDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_key(keyId) do
    delete_key(keyId, [])
  end

  @doc """
  Either one of:
  - `delete_key(keyId, opts)`
  - `delete_key(%{api_key: xyz, host: ...}, keyId)`
  - `delete_key(Connection.new(), keyId)`
  """
  @doc since: "0.4.0"
  @spec delete_key(map() | Connection.t() | integer(), integer() | keyword()) ::
          {:ok, OpenApiTypesense.ApiKeyDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_key(keyId, opts) when is_list(opts) and is_integer(keyId) do
    delete_key(Connection.new(), keyId, opts)
  end

  def delete_key(conn, keyId) do
    delete_key(conn, keyId, [])
  end

  @doc """
  Either one of:
  - `delete_key(%{api_key: xyz, host: ...}, keyId, opts)`
  - `delete_key(Connection.new(), keyId, opts)`
  """
  @doc since: "0.4.0"
  @spec delete_key(map() | Connection.t(), integer(), keyword()) ::
          {:ok, OpenApiTypesense.ApiKeyDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_key(conn, keyId, opts) when not is_struct(conn) and is_map(conn) do
    delete_key(Connection.new(conn), keyId, opts)
  end

  def delete_key(%Connection{} = conn, keyId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [keyId: keyId],
      call: {OpenApiTypesense.Keys, :delete_key},
      url: "/keys/#{keyId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.ApiKeyDeleteResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve (metadata about) a key

  Retrieve (metadata about) a key. Only the key prefix is returned when you retrieve a key. Due to security reasons, only the create endpoint returns the full API key.
  """
  @doc since: "0.4.0"
  @spec get_key(integer()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_key(keyId) do
    get_key(keyId, [])
  end

  @doc """
  Either one of:
  - `get_key(keyId, opts)`
  - `get_key(%{api_key: xyz, host: ...}, keyId)`
  - `get_key(Connection.new(), keyId)`
  """
  @doc since: "0.4.0"
  @spec get_key(map() | Connection.t() | integer(), keyword()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_key(keyId, opts) when is_list(opts) and is_integer(keyId) do
    get_key(Connection.new(), keyId, opts)
  end

  def get_key(conn, keyId) do
    get_key(conn, keyId, [])
  end

  @doc """
  Either one of:
  - `get_key(%{api_key: xyz, host: ...}, keyId, opts)`
  - `get_key(Connection.new(), keyId, opts)`
  """
  @doc since: "0.4.0"
  @spec get_key(map() | Connection.t(), integer(), keyword()) ::
          {:ok, OpenApiTypesense.ApiKey.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_key(conn, keyId, opts) when not is_struct(conn) and is_map(conn) do
    get_key(Connection.new(conn), keyId, opts)
  end

  def get_key(%Connection{} = conn, keyId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [keyId: keyId],
      call: {OpenApiTypesense.Keys, :get_key},
      url: "/keys/#{keyId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.ApiKey, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve (metadata about) all keys.
  """
  @doc since: "0.4.0"
  @spec get_keys :: {:ok, OpenApiTypesense.ApiKeysResponse.t()} | :error
  def get_keys do
    get_keys([])
  end

  @doc """
  Either one of:
  - `get_keys(opts)`
  - `get_keys(%{api_key: xyz, host: ...})`
  - `get_keys(Connection.new())`
  """
  @doc since: "0.4.0"
  @spec get_keys(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.ApiKeysResponse.t()} | :error
  def get_keys(opts) when is_list(opts) do
    get_keys(Connection.new(), opts)
  end

  def get_keys(conn) do
    get_keys(conn, [])
  end

  @doc """
  Either one of:
  - `get_keys(%{api_key: xyz, host: ...}, opts)`
  - `get_keys(Connection.new(), opts)`
  """
  @doc since: "0.4.0"
  @spec get_keys(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.ApiKeysResponse.t()} | :error
  def get_keys(conn, opts) when not is_struct(conn) and is_map(conn) do
    get_keys(Connection.new(conn), opts)
  end

  def get_keys(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Keys, :get_keys},
      url: "/keys",
      method: :get,
      response: [{200, {OpenApiTypesense.ApiKeysResponse, :t}}],
      opts: opts
    })
  end
end
