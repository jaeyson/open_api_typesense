defmodule OpenApiTypesense.Operations do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to operations
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Clears the cache

  Responses of search requests that are sent with use_cache parameter are cached in a LRU cache. Clears cache completely.
  """
  @doc since: "0.4.2"
  @spec clear_cache(keyword) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def clear_cache(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :clear_cache},
      url: "/operations/cache/clear",
      method: :post,
      response: [
        {200, {OpenApiTypesense.SuccessStatus, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Compaction of the underlying RocksDB database

  Typesense uses RocksDB to store your documents on the disk. If you do frequent writes or updates, you could benefit from running a compaction of the underlying RocksDB database. This could reduce the size of the database and decrease read latency. While the database will not block during this operation, we recommend running it during off-peak hours.
  """
  @doc since: "0.4.2"
  @spec compact(keyword) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def compact(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :compact},
      url: "/operations/db/compact",
      method: :post,
      response: [
        {200, {OpenApiTypesense.SuccessStatus, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Enable logging of requests that take over a defined threshold of time.

  Slow requests are logged to the primary log file, with the prefix SLOW REQUEST. Default is -1 which disables slow request logging.
  """
  @doc since: "0.4.2"
  @spec config(OpenApiTypesense.ConfigSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def config body, opts \\ [] do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Operations, :config},
      url: "/config",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.ConfigSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.SuccessStatus, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Get the status of in-progress schema change operations

  Returns the status of any ongoing schema change operations. If no schema changes are in progress, returns an empty response.
  """
  @doc since: "0.7.0"
  @spec get_schema_changes(keyword) ::
          {:ok, [OpenApiTypesense.SchemaChangeStatus.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_schema_changes(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :get_schema_changes},
      url: "/operations/schema_changes",
      method: :get,
      response: [
        {200, [{OpenApiTypesense.SchemaChangeStatus, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Get stats about API endpoints.

  Retrieve the stats about API endpoints.
  """
  @doc since: "0.4.0"
  @spec retrieve_api_stats(keyword) ::
          {:ok, OpenApiTypesense.APIStatsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_api_stats(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :retrieve_api_stats},
      url: "/stats.json",
      method: :get,
      response: [
        {200, {OpenApiTypesense.APIStatsResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Get current RAM, CPU, Disk & Network usage metrics.

  Retrieve the metrics.
  """
  @doc since: "0.4.0"
  @spec retrieve_metrics(keyword) :: {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_metrics(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :retrieve_metrics},
      url: "/metrics.json",
      method: :get,
      response: [{200, :map}, {401, {OpenApiTypesense.ApiResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Creates a point-in-time snapshot of a Typesense node's state and data in the specified directory.

  Creates a point-in-time snapshot of a Typesense node's state and data in the specified directory. You can then backup the snapshot directory that gets created and later restore it as a data directory, as needed.

  ## Options

    * `snapshot_path`: The directory on the server where the snapshot should be saved.

  """
  @doc since: "0.4.0"
  @spec take_snapshot(keyword) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def take_snapshot(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:snapshot_path])

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :take_snapshot},
      url: "/operations/snapshot",
      method: :post,
      query: query,
      response: [
        {201, {OpenApiTypesense.SuccessStatus, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {409, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Triggers a follower node to initiate the raft voting process, which triggers leader re-election.

  Triggers a follower node to initiate the raft voting process, which triggers leader re-election. The follower node that you run this operation against will become the new leader, once this command succeeds.
  """
  @doc since: "0.4.0"
  @spec vote(keyword) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def vote(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Operations, :vote},
      url: "/operations/vote",
      method: :post,
      response: [
        {200, {OpenApiTypesense.SuccessStatus, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
