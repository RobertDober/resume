defmodule Resume.Tools do

  @moduledoc """
  Some tools, better not inside the composer
  """


  @doc """
  Transform tuples of form {key, value} to {key, link(value)} while
  leaving other tuples untouched.
  """
  def make_links_for(data, key) do
    data
    |> Enum.map(_make_link_for(key))
  end

  defp _make_link_for(key) do
    fn {^key, value} -> {key, _make_link(value)}
       otherwise     -> otherwise
    end
  end

  defp _make_link(value) do
    ~s{<a href="#{value}">#{value}</a>}
  end
end
