defmodule JoinTest do
  use ExUnit.Case, async: true

  alias ExTypesense.TestSchema.Person
  alias OpenApiTypesense.ApiResponse
  alias OpenApiTypesense.CollectionResponse
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

    {:ok, _} = ExTypesense.create_collection(author_schema)
    {:ok, _} = ExTypesense.create_collection(book_schema)
    {:ok, _} = ExTypesense.create_collection(order_schema)

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
      {:ok, %{id: id}} = ExTypesense.index_document(author_schema.name, document.author)

      book = Map.put(document.book, :author_id, id)

      {:ok, _} = ExTypesense.index_document(book_schema.name, book)
    end)

    on_exit(fn ->
      {:ok, _} = ExTypesense.drop_collection(author_schema.name)
      {:ok, _} = ExTypesense.drop_collection(book_schema.name)
    end)

    :ok
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-one relation" do
    searches = [
      %{
        collection: "books",
        include_fields: "$authors(first_name,last_name)",
        q: "war",
        query_by: "title"
      }
    ]

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
            }} = ExTypesense.multi_search(searches)
  end

  @tag ["27.1": true, "27.0": true, "26.0": true]
  test "success: one-to-many relation (simple)" do
  end
end
