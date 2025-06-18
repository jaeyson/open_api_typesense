if Mix.env() == :dev do
  defmodule OpenApiTypesense.Plugins.Renderer do
    @moduledoc false
    use OpenAPI.Renderer

    alias OpenAPI.Processor.Naming
    alias OpenAPI.Processor.Operation
    alias OpenAPI.Processor.Operation.Param
    alias OpenAPI.Processor.Schema
    alias OpenAPI.Processor.Schema.Field
    alias OpenAPI.Renderer.State
    alias OpenAPI.Renderer.Util

    @spec render_operation_function(State.t(), Operation.t()) :: Macro.t()
    def render_operation_function(state, operation) do
      %Operation{
        function_name: name,
        request_body: request_body,
        request_path_parameters: path_params
      } = operation

      path_parameter_arguments =
        for %Param{name: name} <- path_params do
          name = Naming.normalize_identifier(name)
          {String.to_atom(name), [], nil}
        end

      body_argument = if not Enum.empty?(request_body), do: quote(do: body)
      opts_argument = quote do: opts \\ []

      arguments = Util.clean_list([path_parameter_arguments, body_argument, opts_argument])

      client =
        quote do
          client = opts[:client] || @default_client
        end

      query = OpenAPI.Renderer.Operation.render_query(operation)
      call = render_call(state, operation)

      operation_body = Util.clean_list([client, query, call])

      quote do
        def unquote(name)(unquote_splicing(arguments)) do
          (unquote_splicing(operation_body))
        end
      end
    end

    @spec render_call(State.t(), Operation.t()) :: Macro.t()
    def render_call(state, operation) do
      %Operation{
        function_name: function_name,
        module_name: module_name,
        request_body: request_body,
        request_method: request_method,
        request_path: request_path,
        request_path_parameters: path_params,
        request_query_parameters: query_params,
        responses: responses
      } = operation

      path_param_args =
        for %Param{name: name} <- path_params do
          name = Naming.normalize_identifier(name)
          arg_as_atom = String.to_atom(name)
          {arg_as_atom, {arg_as_atom, [], nil}}
        end

      body_arg = if not Enum.empty?(request_body), do: {:body, {:body, [], nil}}
      args = Util.clean_list([path_param_args, body_arg])

      args =
        quote do
          {:args, unquote(args)}
        end

      module_name =
        Module.concat([
          config(state)[:base_module],
          module_name
        ])

      call =
        quote do
          {:call, {unquote(module_name), unquote(function_name)}}
        end

      url =
        String.replace(
          request_path,
          ~r/\{([[:word:]]+)\}/,
          &~s(#\{#{Naming.normalize_identifier(&1)}\})
        )
        |> then(&"\"#{&1}\"")
        |> Code.string_to_quoted!()
        |> then(fn url ->
          quote do
            {:url, unquote(url)}
          end
        end)

      method =
        quote do
          {:method, unquote(request_method)}
        end

      body =
        if length(request_body) > 0 do
          quote do
            {:body, body}
          end
        end

      query =
        if length(query_params) > 0 do
          quote do
            {:query, query}
          end
        end

      request =
        OpenAPI.Renderer.Operation.render_call_request_info(
          state,
          request_body,
          config(state)[:operation_call][:request]
        )

      responses =
        if length(responses) > 0 do
          items =
            responses
            |> Enum.sort_by(fn {status_or_default, _schemas} -> status_or_default end)
            |> Enum.map(fn {status_or_default, schemas} ->
              type = Util.to_readable_type(state, {:union, Map.values(schemas)})

              quote do
                {unquote(status_or_default), unquote(type)}
              end
            end)

          quote do
            {:response, unquote(items)}
          end
        end

      options =
        quote do
          {:opts, opts}
        end

      request_details =
        [args, call, url, body, method, query, request, responses, options]
        |> Enum.reject(&is_nil/1)

      quote do
        client.request(%{
          unquote_splicing(request_details)
        })
      end
    end

    @spec render_operation_spec(State.t(), Operation.t()) :: Macro.t()
    def render_operation_spec(state, operation) do
      %Operation{
        function_name: name,
        request_body: request_body,
        request_path_parameters: path_params,
        responses: responses
      } = operation

      path_parameters =
        for %Param{name: name, value_type: type} <- path_params do
          name = Naming.normalize_identifier(name)

          quote(
            do: unquote({String.to_atom(name), [], nil}) :: unquote(Util.to_type(state, type))
          )
        end

      request_body =
        if length(request_body) > 0 do
          body_type = {:union, Enum.map(request_body, fn {_content_type, type} -> type end)}
          quote(do: body :: unquote(Util.to_type(state, body_type)))
        end

      opts = quote(do: opts :: keyword)

      arguments = path_parameters ++ Enum.reject([request_body, opts], &is_nil/1)
      return_type = render_return_type(state, responses)

      quote do
        @spec unquote(name)(unquote_splicing(arguments)) :: unquote(return_type)
      end
    end

    defp render_return_type([], _type_overrides), do: quote(do: :ok)

    defp render_return_type(state, responses) do
      {success, error} =
        responses
        |> Enum.reject(fn {status, schemas} ->
          map_size(schemas) == 0 and status >= 300 and status < 400
        end)
        |> Enum.split_with(fn {status, _schemas} -> status < 300 end)

      ok =
        if length(success) > 0 do
          type =
            success
            |> Enum.map(fn {_state, schemas} -> Map.values(schemas) end)
            |> List.flatten()
            |> then(&Util.to_type(state, {:union, &1}))

          quote(do: {:ok, unquote(type)})
        else
          quote(do: :ok)
        end

      error =
        if error_type = config(state)[:types][:error] do
          quote(do: {:error, unquote(Util.to_type(state, error_type))})
        else
          if length(error) > 0 do
            type =
              error
              |> Enum.map(fn {_state, schemas} -> Map.values(schemas) end)
              |> List.flatten()
              |> then(&Util.to_type(state, {:union, &1}))

            quote(do: {:error, unquote(type)})
          else
            quote(do: :error)
          end
        end

      {:|, [], [ok, error]}
    end

    @spec render_schema_types(state :: State.t(), schemas :: [Schema.t()]) :: Macro.t()
    def render_schema_types(state, schemas) do
      for %Schema{fields: fields, output_format: format, type_name: type} <- schemas do
        fields = render_type_fields(state, fields)

        if format == :struct do
          quote do
            @type unquote({type, [], nil}) :: %__MODULE__{
                    unquote_splicing(fields)
                  }
          end
        else
          quote do
            @type unquote({type, [], nil}) :: %{
                    unquote_splicing(fields)
                  }
          end
        end
        |> Util.put_newlines()
      end
    end

    @spec render_type_fields(State.t(), [Field.t()]) :: Macro.t()
    defp render_type_fields(state, fields) do
      for field <- Enum.sort_by(fields ++ extra_fields(state), & &1.name) do
        %Field{name: name, type: type} = field

        rendered_type = Util.to_type(state, type)

        quote do
          {unquote(String.to_atom(name)), unquote(rendered_type)}
        end
      end
    end

    @spec render_schema_struct(state :: State.t(), schemas :: [Schema.t()]) :: Macro.t()
    def render_schema_struct(state, schemas) do
      case check_empty_fields(schemas) do
        %{fields: impl_fields} = schema when impl_fields != [] ->
          declare_defstruct =
            quote do
              defstruct unquote(schema_struct_fields(state, schemas))
            end

          declare_defimpl =
            OpenApiTypesense
            |> Module.concat(schema.module_name)
            |> declare_defimpl()

          [declare_defstruct, declare_defimpl]

        _ ->
          quote do
            defstruct unquote(schema_struct_fields(state, schemas))
          end
          |> Util.put_newlines()
      end
    end

    @spec declare_defimpl(mod :: atom()) :: Macro.t()
    defp declare_defimpl(mod) do
      quote do
        defimpl Poison.Decoder, for: unquote(mod) do
          def decode(value, %{as: struct}) do
            mod =
              case struct do
                [m] -> m
                m -> m
              end

            filtered_type =
              mod.__struct__.__fields__()
              |> Enum.filter(fn {_field, v} ->
                case v do
                  [{mod, :t}] when is_atom(mod) -> true
                  _ -> false
                end
              end)

            case filtered_type do
              [{_key, [{module, :t}]} | _rest] = list
              when is_list(list) and is_atom(module) ->
                Enum.reduce(list, value, fn {key, [{mod, :t}]}, acc ->
                  Map.update!(acc, key, fn data ->
                    body =
                      OpenApiTypesense.Converter.to_atom_keys(data || [], safe: false)

                    case body do
                      [] ->
                        []

                      _ ->
                        Enum.map(body, &struct(mod, &1))
                    end
                  end)
                end)

              [] ->
                value
            end
          end
        end
      end
    end

    @spec check_empty_fields(schemas :: [Schema.t()]) :: map()
    defp check_empty_fields(schemas) do
      hd(schemas)
      |> Map.from_struct()
      |> Map.update!(:fields, fn fields ->
        Enum.filter(fields, fn field ->
          case field.type do
            {:array, ref} when is_reference(ref) ->
              true

            _ ->
              false
          end
        end)
      end)
    end

    @spec schema_struct_fields(state :: State.t(), schemas :: [Schema.t()]) :: list()
    defp schema_struct_fields(state, schemas) do
      Enum.map(schemas, & &1.fields)
      |> List.insert_at(0, extra_fields(state))
      |> List.flatten()
      |> Enum.map(fn field ->
        case field.default do
          {:ref, {_path, [_components, _schemas, mod_name]}} ->
            ast = {
              :%,
              [],
              [
                {
                  :__aliases__,
                  [alias: false],
                  [:OpenApiTypesense, String.to_atom(mod_name)]
                },
                {:%{}, [], []}
              ]
            }

            {String.to_atom(field.name), quote(do: unquote(ast))}

          nil ->
            String.to_atom(field.name)

          default ->
            {String.to_atom(field.name), default}
        end
      end)
      |> Enum.sort()
      |> Enum.dedup()
    end

    @spec extra_fields(State.t()) :: [Field.t()]
    defp extra_fields(state) do
      extra_fields = config(state)[:extra_fields] || []

      Enum.map(extra_fields, fn {name, type} ->
        %Field{name: to_string(name), nullable: false, private: true, required: true, type: type}
      end)
    end

    @spec config(OpenAPI.Renderer.State.t()) :: Keyword.t()
    defp config(state) do
      %OpenAPI.Renderer.State{profile: profile} = state

      Application.get_env(:oapi_generator, profile, [])
      |> Keyword.get(:output, [])
    end
  end
end
