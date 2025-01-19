defmodule OpenApiTypesense.Analytics do
  @moduledoc """
  Provides API endpoints related to analytics
  """

  alias OpenApiTypesense.Connection

  @default_client OpenApiTypesense.Client

  @doc """
  Create an analytics event

  Sending events for analytics e.g rank search results based on popularity.
  """
  @spec create_analytics_event(map()) ::
          {:ok, OpenApiTypesense.AnalyticsEventCreateResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_event(body) do
    create_analytics_event(Connection.new(), body)
  end

  @doc """
  Either one of:
  - `create_analytics_event(payload, opts)`
  - `create_analytics_event(%{api_key: xyz, host: ...}, payload)`
  - `create_analytics_event(Connection.new(), payload)`
  """
  @spec create_analytics_event(map() | Connection.t(), map() | keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsEventCreateResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_event(body, opts) when is_list(opts) do
    create_analytics_event(Connection.new(), body, opts)
  end

  def create_analytics_event(conn, body) do
    create_analytics_event(conn, body, [])
  end

  @doc """
  Either one of:
  - `create_analytics_event(%{api_key: xyz, host: ...}, payload, opts)`
  - `create_analytics_event(Connection.new(), payload, opts)`
  """
  @spec create_analytics_event(map() | Connection.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsEventCreateResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_event(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    create_analytics_event(Connection.new(conn), body, opts)
  end

  def create_analytics_event(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [body: body],
      call: {OpenApiTypesense.Analytics, :create_analytics_event},
      url: "/analytics/events",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.AnalyticsEventCreateSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.AnalyticsEventCreateResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Creates an analytics rule

  When an analytics rule is created, we give it a name and describe the type, the source collections and the destination collection.
  """
  @spec create_analytics_rule(map()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_rule(body) do
    create_analytics_rule(Connection.new(), body)
  end

  @doc """
  Either one of:
  - `create_analytics_rule(payload, opts)`
  - `create_analytics_rule(%{api_key: xyz, host: ...}, payload)`
  - `create_analytics_rule(Connection.new(), payload)`
  """
  @spec create_analytics_rule(map() | Connection.t(), map() | keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_rule(body, opts) when is_list(opts) do
    create_analytics_rule(Connection.new(), body, opts)
  end

  def create_analytics_rule(conn, body) do
    create_analytics_rule(conn, body, [])
  end

  @doc """
  Either one of:
  - `create_analytics_rule(%{api_key: xyz, host: ...}, payload, opts)`
  - `create_analytics_rule(Connection.new(), payload, opts)`
  """
  @spec create_analytics_rule(map() | Connection.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_rule(conn, body, opts) when not is_struct(conn) and is_map(conn) do
    create_analytics_rule(Connection.new(conn), body, opts)
  end

  def create_analytics_rule(%Connection{} = conn, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [body: body],
      call: {OpenApiTypesense.Analytics, :create_analytics_rule},
      url: "/analytics/rules",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.AnalyticsRuleSchema, :t}}],
      response: [
        {201, {OpenApiTypesense.AnalyticsRuleSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete an analytics rule

  Permanently deletes an analytics rule, given it's name
  """
  @spec delete_analytics_rule(String.t()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_analytics_rule(ruleName) do
    delete_analytics_rule(Connection.new(), ruleName)
  end

  @doc """
  Either one of:
  - `delete_analytics_rule(ruleName, opts)`
  - `delete_analytics_rule(%{api_key: xyz, host: ...}, ruleName)`
  - `delete_analytics_rule(Connection.new(), ruleName)`
  """
  @spec delete_analytics_rule(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_analytics_rule(ruleName, opts) when is_list(opts) and is_binary(ruleName) do
    delete_analytics_rule(Connection.new(), ruleName, opts)
  end

  def delete_analytics_rule(conn, ruleName) do
    delete_analytics_rule(conn, ruleName, [])
  end

  @doc """
  Either one of:
  - `delete_analytics_rule(%{api_key: xyz, host: ...}, ruleName, opts)`
  - `delete_analytics_rule(Connection.new(), ruleName, opts)`
  """
  @spec delete_analytics_rule(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_analytics_rule(conn, ruleName, opts) when not is_struct(conn) and is_map(conn) do
    delete_analytics_rule(Connection.new(conn), ruleName, opts)
  end

  def delete_analytics_rule(%Connection{} = conn, ruleName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [ruleName: ruleName],
      call: {OpenApiTypesense.Analytics, :delete_analytics_rule},
      url: "/analytics/rules/#{ruleName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.AnalyticsRuleDeleteResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves an analytics rule

  Retrieve the details of an analytics rule, given it's name
  """
  @spec retrieve_analytics_rule(String.t()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rule(ruleName) do
    retrieve_analytics_rule(Connection.new(), ruleName)
  end

  @doc """
  Either one of:
  - `retrieve_analytics_rule(ruleName, opts)`
  - `retrieve_analytics_rule(%{api_key: xyz, host: ...}, ruleName)`
  - `retrieve_analytics_rule(Connection.new(), ruleName)`
  """
  @spec retrieve_analytics_rule(map() | Connection.t() | String.t(), String.t() | keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rule(ruleName, opts) when is_list(opts) and is_binary(ruleName) do
    retrieve_analytics_rule(Connection.new(), ruleName, opts)
  end

  def retrieve_analytics_rule(conn, ruleName) do
    retrieve_analytics_rule(conn, ruleName, [])
  end

  @doc """
  Either one of:
  - `retrieve_analytics_rule(%{api_key: xyz, host: ...}, ruleName, opts)`
  - `retrieve_analytics_rule(Connection.new(), ruleName, opts)`
  """
  @spec retrieve_analytics_rule(map() | Connection.t(), String.t(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rule(conn, ruleName, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_analytics_rule(Connection.new(conn), ruleName, opts)
  end

  def retrieve_analytics_rule(%Connection{} = conn, ruleName, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [ruleName: ruleName],
      call: {OpenApiTypesense.Analytics, :retrieve_analytics_rule},
      url: "/analytics/rules/#{ruleName}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.AnalyticsRuleSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves all analytics rules

  Retrieve the details of all analytics rules

  """
  @spec retrieve_analytics_rules ::
          {:ok, OpenApiTypesense.AnalyticsRulesRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rules do
    retrieve_analytics_rules(Connection.new())
  end

  @doc """
  Either one of:
  - `retrieve_analytics_rules(opts)`
  - `retrieve_analytics_rules(%{api_key: xyz, host: ...})`
  - `retrieve_analytics_rules(Connection.new())`
  """
  @spec retrieve_analytics_rules(map() | Connection.t() | keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRulesRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rules(opts) when is_list(opts) do
    retrieve_analytics_rules(Connection.new(), opts)
  end

  def retrieve_analytics_rules(conn) do
    retrieve_analytics_rules(conn, [])
  end

  @doc """
  Either one of:
  - `retrieve_analytics_rules(%{api_key: xyz, host: ...}, opts)`
  - `retrieve_analytics_rules(Connection.new(), opts)`
  """
  @spec retrieve_analytics_rules(map() | Connection.t(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRulesRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rules(conn, opts) when not is_struct(conn) and is_map(conn) do
    retrieve_analytics_rules(Connection.new(conn), opts)
  end

  def retrieve_analytics_rules(%Connection{} = conn, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [],
      call: {OpenApiTypesense.Analytics, :retrieve_analytics_rules},
      url: "/analytics/rules",
      method: :get,
      response: [
        {200, {OpenApiTypesense.AnalyticsRulesRetrieveSchema, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Upserts an analytics rule

  Upserts an analytics rule with the given name.
  """
  @spec upsert_analytics_rule(String.t(), map()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_analytics_rule(ruleName, body) do
    upsert_analytics_rule(Connection.new(), ruleName, body)
  end

  @doc """
  Either one of:
  - `upsert_analytics_rule(ruleName, body, opts)`
  - `upsert_analytics_rule(%{api_key: xyz, host: ...}, ruleName, body)`
  - `upsert_analytics_rule(Connection.new(), ruleName, body)`
  """
  @spec upsert_analytics_rule(
          map() | Connection.t() | String.t(),
          String.t() | map(),
          map() | keyword()
        ) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_analytics_rule(ruleName, body, opts) when is_list(opts) and is_binary(ruleName) do
    upsert_analytics_rule(Connection.new(), ruleName, body, opts)
  end

  def upsert_analytics_rule(conn, ruleName, body) do
    upsert_analytics_rule(conn, ruleName, body, [])
  end

  @doc """
  Either one of:
  - `upsert_analytics_rule(%{api_key: xyz, host: ...}, ruleName, body, opts)`
  - `upsert_analytics_rule(Connection.new(), ruleName, body, opts)`
  """
  @spec upsert_analytics_rule(map() | Connection.t(), String.t(), map(), keyword()) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_analytics_rule(conn, ruleName, body, opts)
      when not is_struct(conn) and is_map(conn) do
    upsert_analytics_rule(Connection.new(conn), ruleName, body, opts)
  end

  def upsert_analytics_rule(%Connection{} = conn, ruleName, body, opts) when is_struct(conn) do
    client = opts[:client] || @default_client

    client.request(conn, %{
      args: [ruleName: ruleName, body: body],
      call: {OpenApiTypesense.Analytics, :upsert_analytics_rule},
      url: "/analytics/rules/#{ruleName}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.AnalyticsRuleUpsertSchema, :t}}],
      response: [
        {200, {OpenApiTypesense.AnalyticsRuleSchema, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
