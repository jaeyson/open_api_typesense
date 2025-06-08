defmodule OpenApiTypesense.Converter do
  defstruct safe: true,
            underscore: true,
            high_perf: false,
            ignore: false

  @spec to_atom_keys(
          map() | list() | tuple() | struct(),
          map() | list() | %__MODULE__{}
        ) :: map() | list() | tuple()
  def to_atom_keys(value, opts \\ %{})

  def to_atom_keys(%{__struct__: _type} = struct, %__MODULE__{} = opts) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> to_atom_keys(opts)
  end

  def to_atom_keys(map, %__MODULE__{} = opts) when is_map(map) do
    Map.new(map, fn {k, v} -> {convert_key(k, opts), to_atom_keys(v, opts)} end)
  end

  def to_atom_keys(list, %__MODULE__{} = opts) when is_list(list) do
    Enum.map(list, &to_atom_keys(&1, opts))
  end

  def to_atom_keys(tuple, %__MODULE__{} = opts) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> to_atom_keys(opts)
    |> List.to_tuple()
  end

  def to_atom_keys(val, _opts = %__MODULE__{}) do
    val
  end

  def to_atom_keys(val, opts = %{}) do
    to_atom_keys(val, struct(__MODULE__, opts))
  end

  def to_atom_keys(val, opts) when is_list(opts) do
    to_atom_keys(val, Enum.into(opts, %{}))
  end

  defp convert_key(key, opts) do
    key
    |> as_underscore(opts.underscore, opts.high_perf)
    |> as_atom(opts.safe, opts.ignore)
  end

  @spec as_atom(String.t() | atom(), safe? :: boolean(), ignore? :: boolean()) ::
          atom() | String.t()
  defp as_atom(key, true, true) when is_binary(key) do
    try do
      as_atom(key, true, false)
    rescue
      ArgumentError -> key
    end
  end

  defp as_atom(key, true, false) when is_binary(key) do
    String.to_existing_atom(key)
  end

  defp as_atom(key, false, _) when is_binary(key) do
    String.to_atom(key)
  end

  defp as_atom(key, _, _), do: key

  @spec as_underscore(
          String.t() | atom(),
          underscore? :: boolean(),
          high_perf? :: boolean()
        ) :: String.t()
  defp as_underscore(key, true, false) when is_binary(key) do
    underscore(key)
  end

  defp as_underscore(key, true, false) when is_atom(key) do
    key
    |> Atom.to_string()
    |> as_underscore(true, false)
  end

  defp as_underscore(key, true, true) when is_binary(key) do
    high_perf_underscore(key)
  end

  defp as_underscore(key, true, true) when is_atom(key) do
    key
    |> Atom.to_string()
    |> as_underscore(true, true)
  end

  defp as_underscore(key, _, _), do: key

  @spec underscore(atom() | String.t()) :: String.t()
  defp underscore(key) do
    key
    |> Macro.underscore()
    |> String.replace(~r/-/, "_")
  end

  @spec high_perf_underscore(String.t() | charlist()) :: String.t() | charlist()
  defp high_perf_underscore(key) when is_binary(key) do
    key
    |> String.to_charlist()
    |> high_perf_underscore()
    |> to_string()
  end

  defp high_perf_underscore([h | t]) do
    [to_lower_char(h)] ++ to_underscore(t, h)
  end

  defp high_perf_underscore(~c"") do
    ~c""
  end

  @spec to_underscore(charlist(), char()) :: charlist()
  defp to_underscore([h | t], prev) when prev == ?_ or prev == ?- do
    [to_lower_char(h)] ++ to_underscore(t, h)
  end

  defp to_underscore([h0, h1 | t], _prev)
       when h0 >= ?A and h0 <= ?Z and not (h1 >= ?A and h1 <= ?Z) and h1 != ?_ and h1 != ?- do
    [?_, to_lower_char(h0), h1] ++ to_underscore(t, h1)
  end

  defp to_underscore([h | t], prev)
       when h >= ?A and h <= ?Z and not (prev >= ?A and prev <= ?Z) and prev != ?_ and prev != ?- do
    [?_, to_lower_char(h)] ++ to_underscore(t, h)
  end

  defp to_underscore([h | t], _prev) do
    [to_lower_char(h)] ++ to_underscore(t, h)
  end

  defp to_underscore(~C"", _h) do
    ~C""
  end

  @spec to_lower_char(char()) :: char()
  defp to_lower_char(?-), do: ?_

  defp to_lower_char(char) when char >= ?A and char <= ?Z do
    char + 32
  end

  defp to_lower_char(char) do
    char
  end
end
