if Mix.env() == :dev do
  defmodule OpenApiTypesense.Plugins.Processor do
    @moduledoc false
    use OpenAPI.Processor

    alias OpenAPI.Processor.Naming
    alias OpenAPI.Processor.Schema
    alias OpenAPI.Processor.State
    alias OpenAPI.Spec.Path.Operation, as: OperationSpec
    alias OpenAPI.Spec.Schema, as: SchemaSpec

    @type module_and_type :: {module :: module, type :: atom}
    @type raw_module_and_type :: {module :: String.t() | nil, type :: String.t()}

    @spec schema_module_and_type(State.t(), Schema.t()) :: {module | nil, atom}
    def schema_module_and_type(state, schema) do
      schema_spec = Map.fetch!(state.schema_specs_by_ref, schema.ref)

      {module, type} =
        raw_schema_module_and_type(state, schema, schema_spec)
        |> Naming.merge_schema(state)
        |> Naming.rename_schema(state)
        |> Naming.group_schema(state)

      if is_nil(module) do
        {module, String.to_atom(type)}
      else
        {Module.concat([module]), String.to_atom(type)}
      end
    end

    @spec raw_schema_module_and_type(State.t(), Schema.t(), SchemaSpec.t()) ::
            {module :: String.t() | nil, type :: String.t()}
    def raw_schema_module_and_type(state, schema, schema_spec)

    def raw_schema_module_and_type(_state, _schema, %SchemaSpec{
          "$oag_last_ref_path": ["components", "schemas", schema_name]
        }) do
      module = Naming.normalize_identifier(schema_name, :camel)
      {module, "t"}
    end

    def raw_schema_module_and_type(_state, _schema, %SchemaSpec{
          "$oag_last_ref_path": ["components", "schemas", schema_name, "items"]
        }) do
      module = Naming.normalize_identifier(schema_name, :camel)
      {module, "t"}
    end

    def raw_schema_module_and_type(_state, _schema, %SchemaSpec{
          "$oag_last_ref_path": [
            "components",
            "responses",
            schema_name,
            "content",
            content_type,
            "schema"
          ]
        }) do
      module = Naming.normalize_identifier(schema_name, :camel)
      type = Enum.join([Naming.readable_content_type(content_type), "resp"], "_")

      {module, type}
    end

    def raw_schema_module_and_type(
          _state,
          %Schema{context: [{:request, op_module, op_function, content_type}]},
          _schema_spec
        ) do
      type = Enum.join([op_function, Naming.readable_content_type(content_type), "req"], "_")

      {inspect(op_module), type}
    end

    def raw_schema_module_and_type(
          _state,
          %Schema{context: [{:response, op_module, op_function, status_code, content_type}]},
          _schema_spec
        ) do
      type =
        Enum.join(
          [
            op_function,
            to_string(status_code),
            Naming.readable_content_type(content_type),
            "resp"
          ],
          "_"
        )

      {inspect(op_module), type}
    end

    def raw_schema_module_and_type(_state, _schema, %SchemaSpec{title: schema_title})
        when is_binary(schema_title) do
      module = Naming.normalize_identifier(schema_title, :camel)
      {module, "t"}
    end

    def raw_schema_module_and_type(
          state,
          %Schema{context: [{:field, parent_ref, field_name}], output_format: :struct},
          _schema_spec
        ) do
      %State{implementation: implementation, schemas_by_ref: schemas_by_ref} = state

      {parent_module, parent_type} =
        case Map.fetch!(schemas_by_ref, parent_ref) do
          %Schema{module_name: nil, type_name: nil} = parent ->
            {parent_module, parent_type} = implementation.schema_module_and_type(state, parent)
            {inspect(parent_module), to_string(parent_type)}

          %Schema{module_name: parent_module, type_name: parent_type} ->
            {inspect(parent_module), to_string(parent_type)}
        end

      module = Enum.join([parent_module, Naming.normalize_identifier(field_name, :snake)])
      {module, parent_type}
    end

    def raw_schema_module_and_type(
          state,
          %Schema{context: [{:field, parent_ref, field_name}], output_format: :typed_map},
          _schema_spec
        ) do
      %State{implementation: implementation, schemas_by_ref: schemas_by_ref} = state

      {parent_module, parent_type} =
        case Map.fetch!(schemas_by_ref, parent_ref) do
          %Schema{module_name: nil, type_name: nil} = parent ->
            {parent_module, parent_type} = implementation.schema_module_and_type(state, parent)
            {inspect(parent_module), to_string(parent_type)}

          %Schema{module_name: parent_module, type_name: parent_type} ->
            {inspect(parent_module), to_string(parent_type)}
        end

      type = Enum.join([parent_type, Naming.normalize_identifier(field_name, :snake)], "_")
      {parent_module, type}
    end

    def raw_schema_module_and_type(_state, _schema, _schema_spec) do
      {nil, "map"}
    end
  end
end
