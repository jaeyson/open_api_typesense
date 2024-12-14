defmodule OpenApiTypesense.Presets do
  @moduledoc """
  Provides API endpoints related to presets
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a preset.

  Permanently deletes a preset, given it's name.
  """
  @spec delete_preset(String.t(), keyword) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(presetId, opts \\ []) do
    delete_preset(Connection.new(), presetId, opts)
  end

  @spec delete_preset(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(conn, presetId, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [presetId: presetId],
      call: {OpenApiTypesense.Presets, :delete_preset},
      url: "/presets/#{presetId}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.PresetDeleteSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves all presets.

  Retrieve the details of all presets
  """
  @spec retrieve_all_presets(keyword) ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()} | :error
  def retrieve_all_presets(opts \\ []) do
    retrieve_all_presets(Connection.new(), opts)
  end

  @spec retrieve_all_presets(Connection.t(), keyword) ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()} | :error
  def retrieve_all_presets(conn, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Presets, :retrieve_all_presets},
      url: "/presets",
      method: :get,
      response: [{200, {OpenApiTypesense.PresetsRetrieveSchema, :t}}],
      opts: opts
    })
  end

  @doc """
  Retrieves a preset.

  Retrieve the details of a preset, given it's name.
  """
  @spec retrieve_preset(String.t(), keyword) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(presetId, opts \\ []) do
    retrieve_preset(Connection.new(), presetId, opts)
  end

  @spec retrieve_preset(Connection.t(), String.t(), keyword) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(conn, presetId, opts) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [presetId: presetId],
      call: {OpenApiTypesense.Presets, :retrieve_preset},
      url: "/presets/#{presetId}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.PresetSchema, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Upserts a preset.

  Create or update an existing preset.
  """
  @spec upsert_preset(
          String.t(),
          OpenApiTypesense.PresetUpsertSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(presetId, body, opts \\ []) do
    upsert_preset(Connection.new(), presetId, body, opts)
  end

  @spec upsert_preset(
          Connection.t(),
          String.t(),
          OpenApiTypesense.PresetUpsertSchema.t(),
          keyword
        ) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(conn, presetId, body, opts) do
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
        {400, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
