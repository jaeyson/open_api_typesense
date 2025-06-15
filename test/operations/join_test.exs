defmodule JoinTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.Documents
  alias OpenApiTypesense.MultiSearchResult
  alias OpenApiTypesense.SearchResult
  alias OpenApiTypesense.SearchResultConversation

  setup_all do
    author_schema = %{
      name: "authors",
      fields: [
        %{name: "first_name", type: "string"},
        %{name: "last_name", type: "string"}
      ]
    }

    book_schema = %{
      name: "books",
      fields: [
        %{name: "title", type: "string"},
        %{name: "author_id", type: "string", reference: "authors.id"}
      ]
    }

    customer_schema = %{
      name: "customers",
      fields: [
        %{name: "forename", type: "string"},
        %{name: "surname", type: "string"},
        %{name: "email", type: "string"}
      ]
    }

    order_schema = %{
      name: "orders",
      fields: [
        %{name: "total_price", type: "float"},
        %{name: "initial_date", type: "int64"},
        %{name: "accepted_date", type: "int64", optional: true},
        %{name: "completed_date", type: "int64", optional: true},
        %{name: "customer_id", type: "string", reference: "customers.id"}
      ]
    }

    product_schema = %{
      name: "join_products",
      fields: [
        %{name: "product_id", type: "string"},
        %{name: "product_name", type: "string"},
        %{name: "product_description", type: "string"}
      ]
    }

    product_variant_schema = %{
      name: "product_variants",
      fields: [
        %{name: "title", type: "string"},
        %{name: "price", type: "float"},
        %{name: "product_id", type: "string", reference: "join_products.product_id"}
      ]
    }

    retailer_schema = %{
      name: "retailers",
      fields: [
        %{name: "title", type: "string"},
        %{name: "location", type: "geopoint"}
      ]
    }

    inventory_schema = %{
      name: "inventory",
      fields: [
        %{name: "qty", type: "int32"},
        %{name: "retailer_id", type: "string", reference: "retailers.id"},
        %{name: "product_variant_id", type: "string", reference: "product_variants.id"}
      ]
    }

    customer_product_prices_schema = %{
      name: "customer_product_prices",
      fields: [
        %{name: "customer_id", type: "string"},
        %{name: "custom_price", type: "float"},
        %{name: "product_id", type: "string", reference: "join_products.product_id"}
      ]
    }

    document_schema = %{
      name: "documents",
      fields: [
        %{name: "id", type: "string"},
        %{name: "title", type: "string"},
        %{name: "content", type: "string"}
      ]
    }

    user_schema = %{
      name: "users",
      fields: [
        %{name: "id", type: "string"},
        %{name: "username", type: "string"}
      ]
    }

    user_doc_access_schema = %{
      name: "user_doc_access",
      fields: [
        %{name: "user_id", type: "string", reference: "users.id"},
        %{name: "document_id", type: "string", reference: "documents.id"}
      ]
    }

    [
      author_schema,
      book_schema,
      customer_schema,
      order_schema,
      product_schema,
      product_variant_schema,
      retailer_schema,
      inventory_schema,
      customer_product_prices_schema,
      document_schema,
      user_schema,
      user_doc_access_schema
    ]
    |> Enum.each(&Collections.create_collection/1)

    [
      %{
        author: %{first_name: "Jane", last_name: "Austen"},
        book: %{title: "Pride and Prejudice"}
      },
      %{
        author: %{first_name: "Mark", last_name: "Twain"},
        book: %{title: "The Adventures of Huckleberry Finn"}
      },
      %{
        author: %{first_name: "Charles", last_name: "Dickens"},
        book: %{title: "Great Expectations"}
      },
      %{
        author: %{first_name: "Virginia", last_name: "Woolf"},
        book: %{title: "To the Lighthouse"}
      },
      %{
        author: %{first_name: "Leo", last_name: "Tolstoy"},
        book: %{title: "War and Peace"}
      },
      %{
        author: %{first_name: "Enid", last_name: "Blyton"},
        book: [
          %{title: "Famous Five"},
          %{title: "Secret Seven"}
        ]
      }
    ]
    |> Enum.map(fn document ->
      {:ok, %{id: id}} = Documents.index_document(author_schema.name, document.author)

      if is_list(document.book) do
        document.book
        |> Enum.map(&Map.put(&1, :author_id, id))
        |> Enum.map(&Documents.index_document(book_schema.name, &1))
      else
        book = Map.put(document.book, :author_id, id)

        {:ok, _} = Documents.index_document(book_schema.name, book)
      end
    end)

    [
      %{
        product_id: "1",
        product_name: "Handcraft Blends Organic Castor Oil",
        product_description: """
        100% Pure and Natural - Premium Grade Carrier Oil for
        Hair Growth, Eyelashes and Eyebrows, Hair and Body
        Expeller-Pressed & Hexane-Free
        """
      },
      %{
        product_id: "2",
        product_name: "Nighttime Aromatherapy Self Care Bundle",
        product_description: """
        Sulfate Free Lavender Shampoo and Conditioner Set Plus
        Dream Essential Oil Blend for Diffusers - Lavender Gift
        for Women with Dreamy Lavender Essential Oil
        """
      }
    ]
    |> Enum.each(fn product ->
      {:ok, _} = Documents.index_document(product_schema.name, product)
    end)

    product_variants = [
      %{title: "Small", price: 19.99, product_id: "1"},
      %{title: "Large", price: 29.99, product_id: "1"},
      %{title: "Standard", price: 39.99, product_id: "2"}
    ]

    variant_ids =
      Enum.map(product_variants, fn variant ->
        {:ok, %{id: id}} = Documents.index_document(product_variant_schema.name, variant)
        id
      end)

    retailers = [
      %{title: "Store Downtown", location: [48.87538726829884, 2.296113163780903]},
      %{title: "Store Uptown", location: [2.296113163780903, 48.87538726829884]}
    ]

    retailer_ids =
      Enum.map(retailers, fn retailer ->
        {:ok, %{id: id}} = Documents.index_document(retailer_schema.name, retailer)
        id
      end)

    [
      %{
        qty: 50,
        retailer_id: Enum.at(retailer_ids, 0),
        product_variant_id: Enum.at(variant_ids, 0)
      },
      %{
        qty: 30,
        retailer_id: Enum.at(retailer_ids, 0),
        product_variant_id: Enum.at(variant_ids, 1)
      },
      %{
        qty: 30,
        retailer_id: Enum.at(retailer_ids, 0),
        product_variant_id: Enum.at(variant_ids, 2)
      },
      %{
        qty: 25,
        retailer_id: Enum.at(retailer_ids, 1),
        product_variant_id: Enum.at(variant_ids, 0)
      },
      %{
        qty: 15,
        retailer_id: Enum.at(retailer_ids, 1),
        product_variant_id: Enum.at(variant_ids, 1)
      },
      %{
        qty: 15,
        retailer_id: Enum.at(retailer_ids, 1),
        product_variant_id: Enum.at(variant_ids, 2)
      }
    ]
    |> Enum.each(fn inventory ->
      {:ok, _} = Documents.index_document(inventory_schema.name, inventory)
    end)

    customers = [
      %{forename: "John", surname: "Smith", email: "john@example.com"},
      %{forename: "Jane", surname: "Doe", email: "jane@example.com"}
    ]

    customer_ids =
      Enum.map(customers, fn customer ->
        {:ok, %{id: id}} = Documents.index_document(customer_schema.name, customer)
        id
      end)

    [
      %{
        total_price: 99.99,
        initial_date: 1_709_251_200,
        accepted_date: 1_709_337_600,
        completed_date: 1_709_424_000,
        customer_id: Enum.at(customer_ids, 0)
      },
      %{
        total_price: 149.99,
        initial_date: 1_709_510_400,
        customer_id: Enum.at(customer_ids, 0)
      },
      %{
        total_price: 199.99,
        initial_date: 1_709_596_800,
        accepted_date: 1_709_683_200,
        customer_id: Enum.at(customer_ids, 1)
      }
    ]
    |> Enum.each(fn order ->
      {:ok, _} = Documents.index_document(order_schema.name, order)
    end)

    [
      %{customer_id: Enum.at(customer_ids, 0), custom_price: 100.0, product_id: "1"},
      %{customer_id: Enum.at(customer_ids, 1), custom_price: 150.0, product_id: "2"}
    ]
    |> Enum.each(fn price ->
      {:ok, _} = Documents.index_document(customer_product_prices_schema.name, price)
    end)

    documents = [
      %{id: "doc1", title: "Document 1", content: "Content 1"},
      %{id: "doc2", title: "Document 2", content: "Content 2"}
    ]

    Enum.each(documents, fn document ->
      {:ok, _} = Documents.index_document(document_schema.name, document)
    end)

    users = [
      %{id: "user1", username: "User 1"},
      %{id: "user2", username: "User 2"}
    ]

    Enum.each(users, fn user ->
      {:ok, _} = Documents.index_document(user_schema.name, user)
    end)

    [
      %{user_id: "user1", document_id: "doc1"},
      %{user_id: "user2", document_id: "doc2"},
      %{user_id: "user1", document_id: "doc2"}
    ]
    |> Enum.each(fn access ->
      {:ok, _} = Documents.index_document(user_doc_access_schema.name, access)
    end)

    on_exit(fn ->
      [
        author_schema.name,
        book_schema.name,
        customer_schema.name,
        order_schema.name,
        product_schema.name,
        product_variant_schema.name,
        retailer_schema.name,
        inventory_schema.name,
        customer_product_prices_schema.name,
        document_schema.name,
        user_schema.name,
        user_doc_access_schema.name
      ]
      |> Enum.each(&Collections.delete_collection/1)
    end)

    :ok
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-one relation" do
    searches = %{
      searches: [
        %{
          collection: "books",
          include_fields: "$authors(first_name,last_name)",
          q: "war",
          query_by: "title"
        }
      ]
    }

    assert {:ok,
            %MultiSearchResult{
              results: [
                %{
                  found: 1,
                  hits: [
                    %{
                      document: %{
                        authors: %{
                          first_name: "Leo",
                          last_name: "Tolstoy"
                        }
                      }
                    }
                  ]
                }
              ]
            }} = Documents.multi_search(searches)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-many relation (simple)" do
    searches = %{
      searches: [
        %{
          collection: "customers",
          q: "*",
          filter_by: "$orders(customer_id:=1)"
        },
        %{
          q: "*",
          collection: "customers",
          filter_by: "$orders(total_price:<100)"
        }
      ]
    }

    assert {:ok,
            %MultiSearchResult{
              results: [
                %{
                  found: 1,
                  hits: [
                    %{
                      document: %{
                        forename: "Jane",
                        surname: "Doe",
                        orders: %{
                          id: "2",
                          total_price: 199.99,
                          initial_date: 1_709_596_800,
                          customer_id: "1"
                        }
                      }
                    }
                  ]
                },
                %{
                  found: 1,
                  hits: [
                    %{
                      document: %{
                        forename: "John",
                        surname: "Smith",
                        orders: %{
                          id: "0",
                          total_price: 99.99,
                          initial_date: 1_709_251_200,
                          customer_id: "0"
                        }
                      }
                    }
                  ]
                }
              ]
            }} = Documents.multi_search(searches)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-many relation (specialized)" do
    searches = %{
      searches: [
        %{
          q: "*",
          collection: "join_products",
          filter_by: "$customer_product_prices(customer_id:=1)"
        },
        %{
          q: "*",
          collection: "join_products",
          filter_by: "$customer_product_prices(customer_id:=1 && custom_price:<=100)"
        }
      ]
    }

    assert {:ok,
            %MultiSearchResult{
              results: [
                %{
                  found: 1,
                  hits: [
                    %{
                      document: %{
                        customer_product_prices: %{
                          custom_price: 150.0
                        }
                      }
                    }
                  ]
                },
                %{found: 0, hits: []}
              ]
            }} = Documents.multi_search(searches)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: merging or nesting joined fields" do
    searches = %{
      searches: [
        %{
          collection: "books",
          include_fields: "$authors(*, strategy: merge)",
          q: "light",
          query_by: "title"
        }
      ]
    }

    assert {:ok,
            %MultiSearchResult{
              results: [
                %{
                  found: 1,
                  hits: [
                    %{
                      document: %{
                        id: "3",
                        title: "To the Lighthouse",
                        first_name: "Virginia",
                        last_name: "Woolf",
                        author_id: "3"
                      },
                      highlights: [
                        %{
                          field: "title",
                          snippet: "To the <mark>Light</mark>house",
                          matched_tokens: ["Light"]
                        }
                      ]
                    }
                  ]
                }
              ]
            }} = Documents.multi_search(searches)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: forcing nested array for joined fields" do
    searches = %{
      searches: [
        %{
          collection: "authors",
          q: "*",
          filter_by: "$books(id:*)",
          include_fields: "$books(*, strategy: nest_array)"
        }
      ]
    }

    assert {:ok,
            %OpenApiTypesense.MultiSearchResult{
              conversation: %SearchResultConversation{},
              results: [
                %{
                  found: 6,
                  hits: [
                    %{
                      document: %{
                        id: "5",
                        first_name: "Enid",
                        last_name: "Blyton",
                        books: [
                          %{id: "5", title: "Famous Five", author_id: "5"},
                          %{id: "6", title: "Secret Seven", author_id: "5"}
                        ]
                      }
                    }
                    | _the_rest_of_documents
                  ]
                }
              ]
            }} = Documents.multi_search(searches)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: left join" do
    opts = [
      collection: "authors",
      q: "*",
      query_by: "first_name",
      filter_by: "$books(author_id:1)"
    ]

    assert {:ok,
            %SearchResult{
              found: 1,
              hits: [
                %{
                  document: %{
                    id: "1",
                    first_name: "Mark",
                    last_name: "Twain",
                    books: %{id: "1", title: "The Adventures of Huckleberry Finn", author_id: "1"}
                  }
                }
              ]
            }} = Documents.search_collection("authors", opts)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: nested joins" do
    opts = [
      q: "shampoo",
      query_by: "product_name,product_description",
      filter_by: "$product_variants( $inventory( $retailers(id:*)))",
      include_fields: "$product_variants(price, $inventory(qty, $retailers(title)))"
    ]

    assert {:ok,
            %SearchResult{
              found: 1,
              hits: [
                %{
                  document: %{
                    id: "1",
                    product_id: "2",
                    product_name: "Nighttime Aromatherapy Self Care Bundle",
                    product_description: """
                    Sulfate Free Lavender Shampoo and Conditioner Set Plus
                    Dream Essential Oil Blend for Diffusers - Lavender Gift
                    for Women with Dreamy Lavender Essential Oil
                    """,
                    product_variants: %{
                      price: 39.99,
                      inventory: [
                        %{retailers: %{title: "Store Downtown"}, qty: 30},
                        %{retailers: %{title: "Store Uptown"}, qty: 15}
                      ]
                    }
                  },
                  highlight: %{
                    product_description: %{
                      snippet: """
                      Sulfate Free Lavender <mark>Shampoo</mark> and Conditioner Set Plus
                      Dream Essential Oil Blend for Diffusers - Lavender Gift
                      for Women with Dreamy Lavender Essential Oil
                      """,
                      matched_tokens: ["Shampoo"]
                    }
                  },
                  highlights: [
                    %{
                      field: "product_description",
                      snippet: """
                      Sulfate Free Lavender <mark>Shampoo</mark> and Conditioner Set Plus
                      Dream Essential Oil Blend for Diffusers - Lavender Gift
                      for Women with Dreamy Lavender Essential Oil
                      """,
                      matched_tokens: ["Shampoo"]
                    }
                  ]
                }
              ]
            }} = Documents.search_collection("join_products", opts)
  end

  @tag ["28.0": true, "27.1": true, "27.0": true, "26.0": true]
  test "success: nested joins (geo radius)" do
    opts = [
      q: "shampoo",
      query_by: "product_name,product_description",
      filter_by:
        "$product_variants( $inventory( $retailers(location:(48.87538726829884, 2.296113163780903, 1km))))",
      include_fields: "$product_variants(price, $inventory(qty, $retailers(title)))"
    ]

    assert {:ok,
            %SearchResult{
              found: 1,
              hits: [
                %{
                  document: %{
                    id: "1",
                    product_id: "2",
                    product_name: "Nighttime Aromatherapy Self Care Bundle",
                    product_description: """
                    Sulfate Free Lavender Shampoo and Conditioner Set Plus
                    Dream Essential Oil Blend for Diffusers - Lavender Gift
                    for Women with Dreamy Lavender Essential Oil
                    """,
                    product_variants: %{
                      price: 39.99,
                      inventory: %{retailers: %{title: "Store Downtown"}, qty: 30}
                    }
                  }
                }
              ]
            }} = Documents.search_collection("join_products", opts)
  end
end
