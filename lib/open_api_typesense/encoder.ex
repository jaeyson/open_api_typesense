defmodule OpenApiTypesense.Encoder do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      # @derive {Jason.Encoder, except: [:__info__]}
      @derive Jason.Encoder
    end
  end
end
