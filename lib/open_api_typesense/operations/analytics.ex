defmodule OpenApiTypesense.Analytics do
  @moduledoc since: "0.4.0"

  @moduledoc """
  Provides API endpoints related to analytics
  """

  @default_client OpenApiTypesense.Client

  @doc """
  Create an analytics event

  Sending events for analytics e.g rank search results based on popularity.
  """
  @doc since: "0.4.0"
  @spec create_analytics_event(OpenApiTypesense.AnalyticsEventCreateSchema.t(), keyword) ::
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
  @doc since: "0.4.0"
  @spec create_analytics_rule(OpenApiTypesense.AnalyticsRuleSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def create_analytics_rule(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
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
  @doc since: "0.4.0"
  @spec delete_analytics_rule(String.t(), keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRuleDeleteResponse.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def delete_analytics_rule(ruleName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [ruleName: ruleName],
      call: {OpenApiTypesense.Analytics, :delete_analytics_rule},
      url: "/analytics/rules/#{ruleName}",
      method: :delete,
      response: [
        {200, {OpenApiTypesense.AnalyticsRuleDeleteResponse, :t}},
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
  @spec retrieve_analytics_rule(String.t(), keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rule(ruleName, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
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
  @doc since: "0.4.0"
  @spec retrieve_analytics_rules(keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRulesRetrieveSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def retrieve_analytics_rules(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
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
  @doc since: "0.4.0"
  @spec upsert_analytics_rule(String.t(), OpenApiTypesense.AnalyticsRuleUpsertSchema.t(), keyword) ::
          {:ok, OpenApiTypesense.AnalyticsRuleSchema.t()}
          | {:error, OpenApiTypesense.ApiResponse.t()}
  def upsert_analytics_rule(ruleName, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
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
