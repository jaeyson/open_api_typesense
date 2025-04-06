defmodule OpenApiTypesense.Presets do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to presets
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a preset.

  Permanently deletes a preset, given it's name.
  """
  @doc since: "0.4.0"
  @spec delete_preset(String.t()) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(presetId) do
    delete_preset(presetId, [])
  end

  @doc """
  Either one of:
  - `delete_preset(presetId, opts)`
  - `delete_preset(%{api_key: xyz, host: ...}, presetId)`
  - `delete_preset(Connection.new(), presetId)`
  """
  @doc since: "0.4.0"
  @spec delete_preset(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(presetId, opts) when is_list(opts) and is_binary(presetId) do
    delete_preset(Connection.new(), presetId, opts)
  end

  def delete_preset(conn, presetId) do
    delete_preset(conn, presetId, [])
  end

  @doc """
  Either one of:
  - `delete_preset(%{api_key: xyz, host: ...}, presetId, opts)`
  - `delete_preset(Connection.new(), presetId, opts)`
  """
  @doc since: "0.4.0"
  @spec delete_preset(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(conn, presetId, opts) when not is_struct(conn) and is_map(conn) do
    delete_preset(Connection.new(conn), presetId, opts)
  end

  def delete_preset(%Connection{} = conn, presetId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [presetId: presetId],
      call: {OpenApiTypesense.Presets, :delete_preset},
      url: "/presets/#{presetId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.PresetDeleteSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves all presets.

  Retrieve the details of all presets
  """
  @doc since: "0.4.0"
  @spec retrieve_all_presets ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_presets do
    retrieve_all_presets([])
  end

  @doc """
  Either one of:
  - `retrieve_all_presets(opts)`
  - `retrieve_all_presets(%{api_key: xyz, host: ...})`
  - `retrieve_all_presets(Connection.new())`
  """
  @doc since: "0.4.0"
  @spec retrieve_all_presets(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_presets(opts) when is_list(opts) do
    retrieve_all_presets(Connection.new(), opts)
  end

  def retrieve_all_presets(conn) do
    retrieve_all_presets(conn, [])
  end

  @doc """
  Either one of:
  - `retrieve_all_presets(%{api_key: xyz, host: ...}, opts)`
  - `retrieve_all_presets(Connection.new(), opts)`
  """
  @doc since: "0.4.0"
  @spec retrieve_all_presets(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_presets(conn, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_all_presets(Connection.new(conn), opts)
  end

  def retrieve_all_presets(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Presets, :retrieve_all_presets},
      url: "/presets",
      method: :get,
      response: [
        {200, {OpenApiTypesense.PresetsRetrieveSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves a preset.

  Retrieve the details of a preset, given it's name.
  """
  @doc since: "0.4.0"
  @spec retrieve_preset(String.t()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(presetId) do
    retrieve_preset(presetId, [])
  end

  @doc """
  Either one of:
  - `retrieve_preset(presetId, opts)`
  - `retrieve_preset(%{api_key: xyz, host: ...}, presetId)`
  - `retrieve_preset(Connection.new(), presetId)`
  """
  @doc since: "0.4.0"
  @spec retrieve_preset(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(presetId, opts) when is_list(opts) and is_binary(presetId) do
    retrieve_preset(Connection.new(), presetId, opts)
  end

  def retrieve_preset(conn, presetId) do
    retrieve_preset(conn, presetId, [])
  end

  @doc """
  Either one of:
  - `retrieve_preset(%{api_key: xyz, host: ...}, presetId, opts)`
  - `retrieve_preset(Connection.new(), presetId, opts)`
  """
  @doc since: "0.4.0"
  @spec retrieve_preset(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(conn, presetId, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_preset(Connection.new(conn), presetId, opts)
  end

  def retrieve_preset(%Connection{} = conn, presetId, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [presetId: presetId],
      call: {OpenApiTypesense.Presets, :retrieve_preset},
      url: "/presets/#{presetId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.PresetSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Upserts a preset.

  Create or update an existing preset.
  """
  @doc since: "0.4.0"
  @spec upsert_preset(String.t(), map()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(presetId, body) do
    upsert_preset(presetId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_preset(presetId, payload, opts)`
  - `upsert_preset(%{api_key: xyz, host: ...}, presetId, payload)`
  - `upsert_preset(Connection.new(), presetId, payload)`
  """
  @doc since: "0.4.0"
  @spec upsert_preset(map() | Connection.t() | String.t(), String.t() | map(), map() | keyword()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(presetId, body, opts) when is_list(opts) and is_binary(presetId) do
    upsert_preset(Connection.new(), presetId, body, opts)
  end

  def upsert_preset(conn, presetId, body) do
    upsert_preset(conn, presetId, body, [])
  end

  @doc """
  Either one of:
  - `upsert_preset(%{api_key: xyz, host: ...}, presetId, payload, opts)`
  - `upsert_preset(Connection.new(), presetId, payload, opts)`
  """
  @doc since: "0.4.0"
  @spec upsert_preset(map() | Connection.t(), String.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(conn, presetId, body, opts) when not is_struct(conn) and is_map(conn) do
    upsert_preset(Connection.new(conn), presetId, body, opts)
  end

  def upsert_preset(%Connection{} = conn, presetId, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [presetId: presetId, body: body],
      call: {OpenApiTypesense.Presets, :upsert_preset},
      url: "/presets/#{presetId}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.PresetUpsertSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.PresetSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
