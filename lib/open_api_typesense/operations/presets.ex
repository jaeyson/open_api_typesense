defmodule OpenApiTypesense.Presets do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to presets
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Delete a preset.

  Permanently deletes a preset, given it's name.
  """
  @doc since: "0.4.0"
  @spec delete_preset(preset_id :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.PresetDeleteSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_preset(preset_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [preset_id: preset_id],
      call: {OpenApiTypesense.Presets, :delete_preset},
      url: "/presets/#{preset_id}",
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
  @spec retrieve_all_presets(opts :: keyword) ::
          {:ok, OpenApiTypesense.PresetsRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_all_presets(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
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
  @spec retrieve_preset(preset_id :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_preset(preset_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [preset_id: preset_id],
      call: {OpenApiTypesense.Presets, :retrieve_preset},
      url: "/presets/#{preset_id}",
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
  @spec upsert_preset(
          preset_id :: String.t(),
          body :: OpenApiTypesense.PresetUpsertSchema.t(),
          opts :: keyword
        ) :: {:ok, OpenApiTypesense.PresetSchema.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_preset(preset_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [preset_id: preset_id, body: body],
      call: {OpenApiTypesense.Presets, :upsert_preset},
      url: "/presets/#{preset_id}",
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
