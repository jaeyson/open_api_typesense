defmodule JoinTest do
  use ExUnit.Case, async: true

  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.CollectionResponse
  alias OpenApiTypesense.Collections
  alias OpenApiTypesense.Connection
  alias OpenApiTypesense.Documents
  alias OpenApiTypesense.MultiSearchResult

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
      name: "products",
      fields: [
        %{name: "product_id", type: "string"},
        %{name: "product_name", type: "string"},
        %{name: "product_description", type: "string"}
      ]
    }

    customer_product_prices_schema = %{
      name: "customer_product_prices",
      fields: [
        %{name: "customer_id", type: "string"},
        %{name: "custom_price", type: "float"},
        %{name: "product_id", type: "string", reference: "products.product_id"}
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

    {:ok, _} = Collections.create_collection(author_schema)
    {:ok, _} = Collections.create_collection(book_schema)
    {:ok, _} = Collections.create_collection(customer_schema)
    {:ok, _} = Collections.create_collection(order_schema)
    {:ok, _} = Collections.create_collection(product_schema)
    {:ok, _} = Collections.create_collection(customer_product_prices_schema)
    {:ok, _} = Collections.create_collection(document_schema)
    {:ok, _} = Collections.create_collection(user_schema)
    {:ok, _} = Collections.create_collection(user_doc_access_schema)

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
      }
    ]
    |> Enum.map(fn document ->
      {:ok, %{id: id}} = Documents.index_document(author_schema.name, document.author)

      book = Map.put(document.book, :author_id, id)

      {:ok, _} = Documents.index_document(book_schema.name, book)
    end)

    [
      %{product_id: "1", product_name: "Product 1", product_description: "Description 1"},
      %{product_id: "2", product_name: "Product 2", product_description: "Description 2"}
    ]
    |> Enum.each(fn product ->
      {:ok, _} = Documents.index_document(product_schema.name, product)
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
      {:ok, _} = Collections.delete_collection(author_schema.name)
      {:ok, _} = Collections.delete_collection(book_schema.name)
      {:ok, _} = Collections.delete_collection(customer_schema.name)
      {:ok, _} = Collections.delete_collection(order_schema.name)
      {:ok, _} = Collections.delete_collection(product_schema.name)
      {:ok, _} = Collections.delete_collection(customer_product_prices_schema.name)
      {:ok, _} = Collections.delete_collection(document_schema.name)
      {:ok, _} = Collections.delete_collection(user_schema.name)
      {:ok, _} = Collections.delete_collection(user_doc_access_schema.name)
    end)

    :ok
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
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

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-many relation (simple)" do
    searches = %{
      searches: [
        %{
          collection: "customers",
          q: "*",
          filter_by: "$orders(customer_id:=customer_a)"
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
                %{found: 0, hits: []},
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

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-many relation (specialized)" do
    searches = %{
      searches: [
        %{
          q: "*",
          collection: "products",
          filter_by: "$customer_product_prices(customer_id:=1)"
        },
        %{
          q: "*",
          collection: "products",
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

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: many-to-many relation" do
    searches = %{
      searches: [
        %{
          q: "*",
          collection: "documents",
          filter_by: "$user_doc_access(user_id:=user1)"
        },
        %{
          q: "*",
          collection: "documents",
          query_by: "title",
          filter_by: "$user_doc_access(id: *)",
          include_fields: "$users(id) as user_identifier"
        }
      ]
    }

    assert {:ok, %MultiSearchResult{results: [%{found: 2}, %{found: 2}]}} =
             Documents.multi_search(searches)
  end
end
