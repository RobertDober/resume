defmodule Resume.Composer do

  def get(cv, keys) when is_binary(keys), do: get(cv, String.split(keys, "."))
  def get(cv, keys, default) when is_binary(keys), do: get(cv, String.split(keys, "."), default)
  def get(cv, keys) do
    keys
    |>  Enum.reduce(cv, fn key, current -> Map.fetch!(current, key) end)
  end
  def get(cv, keys, default) do
    keys
    |>  Enum.reduce_while(cv, &_while_getter(default, &1, &2))
  end

  defp _while_getter(default, key, current) do
    if Map.has_key?(current, key) do
      {:cont, Map.get(current, key)}
    else
      {:halt, default} 
    end
  end

  def gets(cv, keys) do
     case get(cv, keys) do
      nil -> raise "ERROR FetchKey returned nil #{inspect cv} <- #{inspect keys}"
      value when is_list(value) or is_map(value) -> raise "ERROR `gets` can only access scalar values, not #{inspect value}" 
      t   -> to_string(t)
    end
  end

  def only(map, keys) do
    keys
    |> Enum.reduce([], fn k, r -> [Map.fetch!(map, k) | r] end)
    |> Enum.reverse
  end

  def pairs(map, keys) do
    keys
    |> Enum.reduce([], fn k, r -> [{k, Map.fetch!(map, k)} | r] end)
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

  def render_pairs(pairs, tag \\ nil, options \\ []) do
    rendered = Enum.map(pairs, &_render_pair(&1, tag, options))
    {:safe, Enum.join(rendered, "\n") }
  end
  

  def render_tag_cloud(tag_cloud, options \\ [])
  def render_tag_cloud(tag_cloud, _options) when is_binary(tag_cloud) do
    content = File.read!(tag_cloud)
              |> String.split("\n")
              |> Enum.map(&_make_tag/1)
              |> Enum.join("\n")
    {:safe, content}
  end
  def render_tag_cloud(tag_cloud, _options) do
    content = tag_cloud
      |> Enum.map(&_make_tag/1)
      |> Enum.join("\n")
    {:safe, content}
  end

  defp _make_tag(tag_spec)
  defp _make_tag("#" <> _), do: ""
  defp _make_tag(""), do: ""
  defp _make_tag(tag_spec) when is_binary(tag_spec) do 
    {:ok, tag} = tag_spec |> EarmarkTagCloud.one_tag
    tag
  end
  defp _make_tag(%{"color" => color, "item" => item, "size" => size, "weight" => weight}) do
    with {:ok, tag} <- "#{item} #{size} #{weight} #{color}" |> EarmarkTagCloud.one_tag, do: tag
  end

  defp _render(ele, nil, _) do
    ele
  end
  defp _render(ele, tag, options) do
    [ _option_string(tag, options), ">", ele, "</", to_string(tag), ">" ]
    |> IO.iodata_to_binary
  end

  def _render_pair({_, content}, nil, _) do
    content
  end
  def _render_pair({key, content}, tag, options) do
    option_string =
      _option_string(tag, options)
      |> String.replace("%1", key)
    [ option_string, ">", content, "</", to_string(tag), ">" ]
    |> IO.iodata_to_binary
  end

  defp _option_string(tag, options) do
    # IO.inspect(options)
    "<#{tag}" <> (
    options
    |> Enum.map(fn {x, y} -> " #{x}=\"#{y}\"" end)
    |> Enum.join
    )
  end

end
