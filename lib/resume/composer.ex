defmodule Resume.Composer do

  @moduledoc false

  @doc """
  Get an element of a deep map with a compound key.

  Keys can be specified as arrays,

        iex(1)> cv = %{ "sections" =>
        ...(1)>   %{ "header" => %{ "name" => "Robert", "age" => 42 } },
        ...(1)>        "title" => "my CV" }
        ...(1)> Resume.Composer.get(cv, ~w{sections header name})
        "Robert"

  ... or as dot expressions

        iex(2)> cv = %{ "sections" =>
        ...(2)>   %{ "header" => %{ "name" => "Robert", "age" => 42 } },
        ...(2)>        "title" => "my CV" }
        ...(2)> Resume.Composer.get(cv, "sections.header.name")
        "Robert"

  In order to avoid unpleasentness in case of ignorable presence of the key it is
  suggested to provide a default

        iex(3)> cv = %{ "sections" =>
        ...(3)>   %{ "header" => %{ "name" => "Robert", "age" => 42 } },
        ...(3)>        "title" => "my CV" }
        ...(3)> Resume.Composer.get(cv, "sections.title.name", "John Doe")
        "John Doe"
  """
  def get(cv, keys, default \\ nil)
  def get(cv, keys, default) when is_binary(keys), do: get(cv, String.split(keys, "."), default)
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

  @doc """
  Like `get` above, although the precautionary `default` is not available, however,
  to make it up the result is guranteed to be a string (well if found).
  Either by calling `to_string`

        iex(4)> cv = %{ "person" => %{ "name"  => "Robert", 
        ...(4)>                        "age"   => 42,
        ...(4)>                        "langs" => ~w{elixir julia haskell} } }
        ...(4)> Resume.Composer.gets(cv, "person.age")
        "42"

  ... or by joining an Enum together

        iex(5)> cv = %{ "person" => %{ "name"  => "Robert", 
        ...(5)>                        "age"   => 42,
        ...(5)>                        "langs" => ~w{elixir julia haskell} } }
        ...(5)> Resume.Composer.gets(cv, ~w{person langs})
        "elixir julia haskell" 

  One can join with other things than spaces, of course:

        iex(6)> cv = %{ "person" => %{ "name"  => "Robert", 
        ...(6)>                        "age"   => 42,
        ...(6)>                        "langs" => ~w{elixir julia haskell} } }
        ...(6)> Resume.Composer.gets(cv, ~w{person langs}, ", ")
        "elixir, julia, haskell" 

  Prefixes can come in handy too:

        iex(7)> cv = %{ "person" => %{ "name"  => "Robert", 
        ...(7)>                        "age"   => 42,
        ...(7)>                        "langs" => ~w{elixir julia haskell} } }
        ...(7)> Resume.Composer.gets(cv, ~w{person langs}, ", ", prefix: ">")
        ">elixir, >julia, >haskell" 

  The interface is versatile enough, not to need an explicit joiner for prefixes:

        iex(7)> cv = %{ "person" => %{ "name"  => "Robert", 
        ...(7)>                        "age"   => 42,
        ...(7)>                        "langs" => ~w{elixir julia haskell} } }
        ...(7)> Resume.Composer.gets(cv, ~w{person langs}, prefix: ">")
        ">elixir >julia >haskell" 

  """
  def gets(cv, keys, joiner \\ " ", options \\ [])
  def gets(cv, keys, joiner,  _options) when is_list(joiner) do
    gets(cv, keys, " ", joiner)
  end
  def gets(cv, keys, joiner, options ) do
    prefix = Keyword.get(options, :prefix, "")
       case get(cv, keys) do
        nil -> raise "ERROR FetchKey returned nil #{inspect cv} <- #{inspect keys}"
        value when is_list(value) -> Enum.join(Enum.map(value, _prefix_with_fn(prefix)), joiner)
        value when is_map(value) -> raise "ERROR `gets` can only access scalar values, not #{inspect value}" 
        t   -> to_string(t)
      end
  end

  @doc """
  Get the list of values corresponding to the keys from a map.

        iex(8)> map = %{1 => "one", 2 => "two", 3 => "three", 4 => "four"}
        ...(8)> primes = [2, 3]
        ...(8)> Resume.Composer.only(map, primes)
        ~w{two three}
  """
  def only(map, keys) do
    keys
    |> Enum.reduce([], fn k, r -> [Map.fetch!(map, k) | r] end)
    |> Enum.reverse
  end

  @doc """
  Like `only` but return the keys too, thus the result is a list of pairs

        iex(9)> map = %{1 => "one", 2 => "two", 3 => "three", 4 => "four"}
        ...(9)> primes = [2, 3]
        ...(9)> Resume.Composer.pairs(map, primes)
        [{2, "two"}, {3, "three"}]

  In case of symbol keys, this will get us a result of type `Keyword.t`

        iex(10)> map = %{three: 3, four: 4, five: 5}
        ...(10)> primes = ~w{three five}a
        ...(10)> Resume.Composer.pairs(map, primes)
        [three: 3, five: 5]
  """
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
    rendered = _render(ele, tag, options)
    { :safe, rendered }
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

  defp _prefix_with_fn(prefix) do
    fn x -> [prefix, x] |> Enum.join end
  end

  defp _render(ele, nil, options) do
    if Keyword.get(options, :markdown) do
      Earmark.as_html!(ele)
    else
      ele
    end
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
