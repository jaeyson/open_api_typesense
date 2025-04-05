defmodule OpenApiTypesense.Operations do
  @moduledoc """
  Provides API endpoints related to operations
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Clears the cache

  Responses of search requests that are sent with use_cache parameter are cached in a LRU cache. Clears cache completely.
  """
  @spec clear_cache ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def clear_cache do
    clear_cache([])
  end

  @doc """
  Either one of:
  - `clear_cache(opts)`
  - `clear_cache(%{api_key: xyz, host: ...})`
  - `clear_cache(Connection.new())`
  """
  @spec clear_cache(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def clear_cache(opts) when is_list(opts) do
    clear_cache(Connection.new(), opts)
  end

  def clear_cache(conn) do
    clear_cache(conn, [])
  end

  @doc """
  Either one of:
  - `clear_cache(%{api_key: xyz, host: ...}, opts)`
  - `clear_cache(Connection.new(), opts)`
  """
  @spec clear_cache(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def clear_cache(conn, opts) when not is_struct(conn) and is_map(conn) do
    clear_cache(Connection.new(conn), opts)
  end

  def clear_cache(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec compact ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def compact do
    compact([])
  end

  @doc """
  Either one of:
  - `compact(opts)`
  - `compact(%{api_key: xyz, host: ...})`
  - `compact(Connection.new())`
  """
  @spec compact(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def compact(opts) when is_list(opts) do
    compact(Connection.new(), opts)
  end

  def compact(conn) do
    compact(conn, [])
  end

  @doc """
  Either one of:
  - `compact(%{api_key: xyz, host: ...}, opts)`
  - `compact(Connection.new(), opts)`
  """
  @spec compact(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def compact(conn, opts) when not is_struct(conn) and is_map(conn) do
    compact(Connection.new(conn), opts)
  end

  def compact(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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

  ## Example
      iex> body = %{"log_slow_requests_time_ms" => 2_000}
      iex> OpenApiTypesense.Operations.config(body)

  """
  @spec config(map()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def config(body) do
    config(body, [])
  end

  @doc """
  Either one of:
  - `config(payload, opts)`
  - `config(%{api_key: xyz, host: ...}, payload)`
  - `config(Connection.new(), payload)`
  """
  @spec config(map() | Connection.t(), map() | keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def config(body, opts) when is_list(opts) and is_map(body) do
    config(Connection.new(), body, opts)
  end

  def config(conn, body) do
    config(conn, body, [])
  end

  @doc """
  Either one of:
  - `config(%{api_key: xyz, host: ...}, payload, opts)`
  - `config(Connection.new(), payload, opts)`
  """
  @spec config(map() | Connection.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def config(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    config(Connection.new(conn), body, opts)
  end

  def config(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec get_schema_changes :: {:ok, [OpenApiTypesense.SchemaChangeStatus.t()]} | :error
  def get_schema_changes do
    get_schema_changes([])
  end

  @doc """
  Either one of:
  - `get_schema_changes(opts)`
  - `get_schema_changes(%{api_key: xyz, host: ...})`
  - `get_schema_changes(Connection.new())`
  """
  @doc since: "0.7.0"
  @spec get_schema_changes(map() | Connection.t() | keyword()) ::
          {:ok, [OpenApiTypesense.SchemaChangeStatus.t()]} | :error
  def get_schema_changes(opts) when is_list(opts) do
    get_schema_changes(Connection.new(), opts)
  end

  def get_schema_changes(conn) do
    get_schema_changes(conn, [])
  end

  @doc """
  Either one of:
  - `get_schema_changes(%{api_key: xyz, host: ...}, opts)`
  - `get_schema_changes(Connection.new(), opts)`
  """
  @doc since: "0.7.0"
  @spec get_schema_changes(map() | Connection.t(), keyword()) ::
          {:ok, [OpenApiTypesense.SchemaChangeStatus.t()]} | :error
  def get_schema_changes(conn, opts) when not is_struct(conn) and is_map(conn) do
    get_schema_changes(Connection.new(conn), opts)
  end

  def get_schema_changes(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec retrieve_api_stats ::
          {:ok, OpenApiTypesense.APIStatsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_api_stats do
    retrieve_api_stats([])
  end

  @doc """
  Either one of:
  - `retrieve_api_stats(opts)`
  - `retrieve_api_stats(%{api_key: xyz, host: ...})`
  - `retrieve_api_stats(Connection.new())`
  """
  @spec retrieve_api_stats(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.APIStatsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_api_stats(opts) when is_list(opts) do
    retrieve_api_stats(Connection.new(), opts)
  end

  def retrieve_api_stats(conn) do
    retrieve_api_stats(conn, [])
  end

  @doc """
  Either one of:
  - `retrieve_api_stats(%{api_key: xyz, host: ...}, opts)`
  - `retrieve_api_stats(Connection.new(), opts)`
  """
  @spec retrieve_api_stats(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.APIStatsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_api_stats(conn, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_api_stats(Connection.new(conn), opts)
  end

  def retrieve_api_stats(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
  @spec retrieve_metrics :: {:ok, map} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_metrics do
    retrieve_metrics([])
  end

  @doc """
  Either one of:
  - `retrieve_metrics(opts)`
  - `retrieve_metrics(%{api_key: xyz, host: ...})`
  - `retrieve_metrics(Connection.new())`
  """
  @spec retrieve_metrics(map() | Connection.t() | keyword()) ::
          {:ok, map()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_metrics(opts) when is_list(opts) do
    retrieve_metrics(Connection.new(), opts)
  end

  def retrieve_metrics(conn) do
    retrieve_metrics(conn, [])
  end

  @doc """
  Either one of:
  - `retrieve_metrics(%{api_key: xyz, host: ...}, opts)`
  - `retrieve_metrics(Connection.new(), opts)`
  """
  @spec retrieve_metrics(map() | Connection.t(), keyword()) ::
          {:ok, map()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_metrics(conn, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_metrics(Connection.new(conn), opts)
  end

  def retrieve_metrics(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Operations, :retrieve_metrics},
      url: "/metrics.json",
      method: :get,
      response: [
        {200, :map},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Creates a point-in-time snapshot of a Typesense node's state and data in the specified directory.

  Creates a point-in-time snapshot of a Typesense node's state and data in the specified directory. You can then backup the snapshot directory that gets created and later restore it as a data directory, as needed.

  ## Options

    * `snapshot_path`: The directory on the server where the snapshot should be saved.

  """
  @spec take_snapshot(keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def take_snapshot(opts) do
    take_snapshot(Connection.new(), opts)
  end

  @doc """
  Either one of:
  - `take_snapshot(%{api_key: xyz, host: ...}, opts)`
  - `take_snapshot(Connection.new(), opts)`
  """
  @spec take_snapshot(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def take_snapshot(conn, opts) when not is_struct(conn) and is_map(conn) do
    take_snapshot(Connection.new(conn), opts)
  end

  def take_snapshot(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:snapshot_path])

    client.request(conn, %{
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
  @spec vote ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def vote do
    vote([])
  end

  @doc """
  Either one of:
  - `vote(opts)`
  - `vote(%{api_key: xyz, host: ...})`
  - `vote(Connection.new())`
  """
  @spec vote(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def vote(opts) when is_list(opts) do
    vote(Connection.new(), opts)
  end

  def vote(conn) do
    vote(conn, [])
  end

  @doc """
  Either one of:
  - `vote(%{api_key: xyz, host: ...}, opts)`
  - `vote(Connection.new(), opts)`
  """
  @spec vote(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.SuccessStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def vote(conn, opts) when not is_struct(conn) and is_map(conn) do
    vote(Connection.new(conn), opts)
  end

  def vote(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
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
