defmodule Resume.Composer do

  def get(cv, keys)
  def get(cv, keys) when is_binary(keys), do: get(cv, String.split(keys, "."))
  def get(cv, keys) do
    keys
    |>  Enum.reduce(cv, fn key, current -> Map.fetch!(current, key) end)
  end

  def only(map, keys) do
    keys
    |> Enum.reduce([], fn k, r -> [Map.fetch!(map, k) | r] end)
    |> Enum.reverse
  end

  def render(eles, tag \\ nil, options \\ [])
  def render(eles, tag, options) when is_list(eles) do
    rendered = Enum.map(eles, &_render(&1, tag, options))
    {:safe, Enum.join(rendered, "\n") }
  end
  def render(ele, tag, options) do
    { :safe, _render(ele, tag, options) }
  end

  defp _render(ele, nil, _) do
    ele
  end
  defp _render(ele, tag, options) do
    [ _option_string(tag, options), ">", ele, "</", to_string(tag), ">" ]
    |> IO.iodata_to_binary
  end


  defp _option_string(tag, options) do
    "<#{tag}" <> (
    options
    |> Enum.map(fn {x, y} -> " #{x}=\"#{y}\"" end)
    |> Enum.join
    )
  end

end
