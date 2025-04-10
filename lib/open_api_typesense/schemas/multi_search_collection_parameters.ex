defmodule OpenApiTypesense.MultiSearchCollectionParameters do
  @moduledoc """
  Provides struct and type for a MultiSearchCollectionParameters
  """

  @type t :: %__MODULE__{
          cache_ttl: integer | nil,
          collection: String.t() | nil,
          conversation: boolean | nil,
          conversation_id: String.t() | nil,
          conversation_model_id: String.t() | nil,
          drop_tokens_mode: String.t() | nil,
          drop_tokens_threshold: integer | nil,
          enable_overrides: boolean | nil,
          enable_synonyms: boolean | nil,
          enable_typos_for_alpha_numerical_tokens: boolean | nil,
          enable_typos_for_numerical_tokens: boolean | nil,
          exclude_fields: String.t() | nil,
          exhaustive_search: boolean | nil,
          facet_by: String.t() | nil,
          facet_query: String.t() | nil,
          facet_return_parent: String.t() | nil,
          facet_strategy: String.t() | nil,
          filter_by: String.t() | nil,
          filter_curated_hits: boolean | nil,
          group_by: String.t() | nil,
          group_limit: integer | nil,
          group_missing_values: boolean | nil,
          hidden_hits: String.t() | nil,
          highlight_affix_num_tokens: integer | nil,
          highlight_end_tag: String.t() | nil,
          highlight_fields: String.t() | nil,
          highlight_full_fields: String.t() | nil,
          highlight_start_tag: String.t() | nil,
          include_fields: String.t() | nil,
          infix: String.t() | nil,
          limit: integer | nil,
          max_extra_prefix: integer | nil,
          max_extra_suffix: integer | nil,
          max_facet_values: integer | nil,
          min_len_1typo: integer | nil,
          min_len_2typo: integer | nil,
          num_typos: String.t() | nil,
          offset: integer | nil,
          override_tags: String.t() | nil,
          page: integer | nil,
          per_page: integer | nil,
          pinned_hits: String.t() | nil,
          pre_segmented_query: boolean | nil,
          prefix: String.t() | nil,
          preset: String.t() | nil,
          prioritize_exact_match: boolean | nil,
          prioritize_num_matching_fields: boolean | nil,
          prioritize_token_position: boolean | nil,
          q: String.t() | nil,
          query_by: String.t() | nil,
          query_by_weights: String.t() | nil,
          remote_embedding_num_tries: integer | nil,
          remote_embedding_timeout_ms: integer | nil,
          rerank_hybrid_matches: boolean | nil,
          search_cutoff_ms: integer | nil,
          snippet_threshold: integer | nil,
          sort_by: String.t() | nil,
          stopwords: String.t() | nil,
          synonym_num_typos: integer | nil,
          synonym_prefix: boolean | nil,
          text_match_type: String.t() | nil,
          typo_tokens_threshold: integer | nil,
          use_cache: boolean | nil,
          vector_query: String.t() | nil,
          voice_query: String.t() | nil,
          "x-typesense-api-key": String.t() | nil
        }

  defstruct [
    :cache_ttl,
    :collection,
    :conversation,
    :conversation_id,
    :conversation_model_id,
    :drop_tokens_mode,
    :drop_tokens_threshold,
    :enable_overrides,
    :enable_synonyms,
    :enable_typos_for_alpha_numerical_tokens,
    :enable_typos_for_numerical_tokens,
    :exclude_fields,
    :exhaustive_search,
    :facet_by,
    :facet_query,
    :facet_return_parent,
    :facet_strategy,
    :filter_by,
    :filter_curated_hits,
    :group_by,
    :group_limit,
    :group_missing_values,
    :hidden_hits,
    :highlight_affix_num_tokens,
    :highlight_end_tag,
    :highlight_fields,
    :highlight_full_fields,
    :highlight_start_tag,
    :include_fields,
    :infix,
    :limit,
    :max_extra_prefix,
    :max_extra_suffix,
    :max_facet_values,
    :min_len_1typo,
    :min_len_2typo,
    :num_typos,
    :offset,
    :override_tags,
    :page,
    :per_page,
    :pinned_hits,
    :pre_segmented_query,
    :prefix,
    :preset,
    :prioritize_exact_match,
    :prioritize_num_matching_fields,
    :prioritize_token_position,
    :q,
    :query_by,
    :query_by_weights,
    :remote_embedding_num_tries,
    :remote_embedding_timeout_ms,
    :rerank_hybrid_matches,
    :search_cutoff_ms,
    :snippet_threshold,
    :sort_by,
    :stopwords,
    :synonym_num_typos,
    :synonym_prefix,
    :text_match_type,
    :typo_tokens_threshold,
    :use_cache,
    :vector_query,
    :voice_query,
    :"x-typesense-api-key"
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      cache_ttl: :integer,
      collection: {:string, :generic},
      conversation: :boolean,
      conversation_id: {:string, :generic},
      conversation_model_id: {:string, :generic},
      drop_tokens_mode: {:enum, ["right_to_left", "left_to_right", "both_sides:3"]},
      drop_tokens_threshold: :integer,
      enable_overrides: :boolean,
      enable_synonyms: :boolean,
      enable_typos_for_alpha_numerical_tokens: :boolean,
      enable_typos_for_numerical_tokens: :boolean,
      exclude_fields: {:string, :generic},
      exhaustive_search: :boolean,
      facet_by: {:string, :generic},
      facet_query: {:string, :generic},
      facet_return_parent: {:string, :generic},
      facet_strategy: {:string, :generic},
      filter_by: {:string, :generic},
      filter_curated_hits: :boolean,
      group_by: {:string, :generic},
      group_limit: :integer,
      group_missing_values: :boolean,
      hidden_hits: {:string, :generic},
      highlight_affix_num_tokens: :integer,
      highlight_end_tag: {:string, :generic},
      highlight_fields: {:string, :generic},
      highlight_full_fields: {:string, :generic},
      highlight_start_tag: {:string, :generic},
      include_fields: {:string, :generic},
      infix: {:string, :generic},
      limit: :integer,
      max_extra_prefix: :integer,
      max_extra_suffix: :integer,
      max_facet_values: :integer,
      min_len_1typo: :integer,
      min_len_2typo: :integer,
      num_typos: {:string, :generic},
      offset: :integer,
      override_tags: {:string, :generic},
      page: :integer,
      per_page: :integer,
      pinned_hits: {:string, :generic},
      pre_segmented_query: :boolean,
      prefix: {:string, :generic},
      preset: {:string, :generic},
      prioritize_exact_match: :boolean,
      prioritize_num_matching_fields: :boolean,
      prioritize_token_position: :boolean,
      q: {:string, :generic},
      query_by: {:string, :generic},
      query_by_weights: {:string, :generic},
      remote_embedding_num_tries: :integer,
      remote_embedding_timeout_ms: :integer,
      rerank_hybrid_matches: :boolean,
      search_cutoff_ms: :integer,
      snippet_threshold: :integer,
      sort_by: {:string, :generic},
      stopwords: {:string, :generic},
      synonym_num_typos: :integer,
      synonym_prefix: :boolean,
      text_match_type: {:string, :generic},
      typo_tokens_threshold: :integer,
      use_cache: :boolean,
      vector_query: {:string, :generic},
      voice_query: {:string, :generic},
      "x-typesense-api-key": {:string, :generic}
    ]
  end
end
