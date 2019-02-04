defmodule Resume.Composer do

  def get(cv, keys, tags \\ nil)
  def get(cv, keys, tags) when is_binary(keys), do: get(cv, String.split(keys, "."), tags)
  def get(cv, keys, tags) do
    keys
    |>  Enum.reduce(cv, fn key, current -> Map.get(current, key) end)
    |> _tag(tags)
  end

  def get_many(cv, keys, values, tags \\ nil) do
    get(cv, keys)
    |> values_at(values)
    |> Enum.map(fn val ->
      if tags do
        {:safe,"<#{tags}>#{val}</#{tags}>"}
      else
        {:safe, val}
      end

    end)
  end

  def values_at(collection, values) do
    values
    |> Enum.reduce([], fn key, res -> [ Map.get(collection, key) | res ] end)
    |> Enum.reverse
  end

  defp _tag(content, tags)
  defp _tag(content, _) when is_map(content), do: content
  defp _tag(content, nil), do: {:safe, content}
  defp _tag(content, symbol), do: {:safe, "<#{symbol}>#{content}</#{symbol}>"}
end
