defmodule OpenApiTypesense.Analytics do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to analytics
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Create an analytics event

  Submit a single analytics event. The event must correspond to an existing analytics rule by name.

  ## Request Body

  **Content Types**: `application/json`

  The analytics event to be created
  """
  @doc since: "0.4.0"
  @spec create_analytics_event(body :: OpenApiTypesense.AnalyticsEvent.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsEventCreateResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_event(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Analytics, :create_analytics_event},
      url: "/analytics/events",
      body: body,
      method: :post,
      request: [{"application/json", {OpenApiTypesense.AnalyticsEvent, :t}}],
      response: [
        {200, {OpenApiTypesense.AnalyticsEventCreateResponse, :t}},
        {201, {OpenApiTypesense.AnalyticsEventCreateResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Create analytics rule(s)

  Create one or more analytics rules. You can send a single rule object or an array of rule objects.

  ## Request Body

  **Content Types**: `application/json`

  The analytics rule(s) to be created
  """
  @doc since: "0.4.0"
  @spec create_analytics_rule(
          body ::
            OpenApiTypesense.AnalyticsRuleCreate.t() | [OpenApiTypesense.AnalyticsRuleCreate.t()],
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.AnalyticsRule.t() | [map | OpenApiTypesense.AnalyticsRule.t()]}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_rule(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {OpenApiTypesense.Analytics, :create_analytics_rule},
      url: "/analytics/rules",
      body: body,
      method: :post,
      request: [
        {"application/json",
         {:union,
          [
            {OpenApiTypesense.AnalyticsRuleCreate, :t},
            [{OpenApiTypesense.AnalyticsRuleCreate, :t}]
          ]}}
      ],
      response: [
        {200,
         {:union,
          [
            {OpenApiTypesense.AnalyticsRule, :t},
            [union: [:map, {OpenApiTypesense.AnalyticsRule, :t}]]
          ]}},
        {201,
         {:union,
          [
            {OpenApiTypesense.AnalyticsRule, :t},
            [union: [:map, {OpenApiTypesense.AnalyticsRule, :t}]]
          ]}},
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
  @doc since: "0.4.0"
  @spec delete_analytics_rule(rule_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRule.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_analytics_rule(rule_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [rule_name: rule_name],
      call: {OpenApiTypesense.Analytics, :delete_analytics_rule},
      url: "/analytics/rules/#{rule_name}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.AnalyticsRule, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Flush in-memory analytics to disk

  Triggers a flush of analytics data to persistent storage.
  """
  @doc since: "1.1.0"
  @spec flush_analytics(opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsEventCreateResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def flush_analytics(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Analytics, :flush_analytics},
      url: "/analytics/flush",
      method: :post,
      response: [
        {200, {OpenApiTypesense.AnalyticsEventCreateResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve analytics events

  Retrieve the most recent events for a user and rule.

  ## Options

    * `user_id`
    * `name`: Analytics rule name
    * `n`: Number of events to return (max 1000)

  """
  @doc since: "1.1.0"
  @spec get_analytics_events(opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsEventsResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_analytics_events(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:n, :name, :user_id])

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Analytics, :get_analytics_events},
      url: "/analytics/events",
      method: :get,
      query: query,
      response: [
        {200, {OpenApiTypesense.AnalyticsEventsResponse, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Get analytics subsystem status

  Returns sizes of internal analytics buffers and queues.
  """
  @doc since: "1.1.0"
  @spec get_analytics_status(opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsStatus.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def get_analytics_status(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Analytics, :get_analytics_status},
      url: "/analytics/status",
      method: :get,
      response: [
        {200, {OpenApiTypesense.AnalyticsStatus, :t}},
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
  @doc since: "0.4.0"
  @spec retrieve_analytics_rule(rule_name :: String.t(), opts :: keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRule.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rule(rule_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [rule_name: rule_name],
      call: {OpenApiTypesense.Analytics, :retrieve_analytics_rule},
      url: "/analytics/rules/#{rule_name}",
      method: :get,
      response: [
        {200, {OpenApiTypesense.AnalyticsRule, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}},
        {404, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieve analytics rules

  Retrieve all analytics rules. Use the optional rule_tag filter to narrow down results.

  ## Options

    * `rule_tag`: Filter rules by rule_tag

  """
  @doc since: "0.4.0"
  @spec retrieve_analytics_rules(opts :: keyword) ::
          {:ok, [OpenApiTypesense.AnalyticsRule.t()]} | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rules(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:rule_tag])

    client.request(%{
      args: [],
      call: {OpenApiTypesense.Analytics, :retrieve_analytics_rules},
      url: "/analytics/rules",
      method: :get,
      query: query,
      response: [
        {200, [{OpenApiTypesense.AnalyticsRule, :t}]},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Upserts an analytics rule

  Upserts an analytics rule with the given name.

  ## Request Body

  **Content Types**: `application/json`

  The Analytics rule to be upserted
  """
  @doc since: "0.4.0"
  @spec upsert_analytics_rule(
          rule_name :: String.t(),
          body :: OpenApiTypesense.AnalyticsRuleUpdate.t(),
          opts :: keyword
        ) ::
          {:ok, OpenApiTypesense.AnalyticsRule.t()} | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_analytics_rule(rule_name, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [rule_name: rule_name, body: body],
      call: {OpenApiTypesense.Analytics, :upsert_analytics_rule},
      url: "/analytics/rules/#{rule_name}",
      body: body,
      method: :put,
      request: [{"application/json", {OpenApiTypesense.AnalyticsRuleUpdate, :t}}],
      response: [
        {200, {OpenApiTypesense.AnalyticsRule, :t}},
        {400, {OpenApiTypesense.ApiResponse, :t}},
        {401, {OpenApiTypesense.ApiResponse, :t}}
      ],
      opts: opts
    })
  end
end
