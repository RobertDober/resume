defmodule Lab42.Html.Dl do
  @moduledoc """
  Create a defintion list...
  """

  @doc """
  Given an array representing the data of the `<dl>` tag, returns the
  corresponding HTML.

        iex(0)> data = [
        ...(0)> [["first dt content", class: "dt"], ["first dd content"]],
        ...(0)> [["second dt content", class: "dt"], ["second dd content", class: "second"]]
        ...(0)> ]
        ...(0)> dl(data)
        {:safe, ~s{<dl>\\n<dt class="dt">first dt content</dt>\\n<dd>first dd content</dd>\\n<dt class="dt">second dt content</dt>\\n<dd class="second">second dd content</dd>\\n</dl>\\n}}

  """
  def dl(data) do
    {
      :safe,
      ["<dl>\n", _dl_rows(data), "</dl>\n"] |> IO.iodata_to_binary }
  end


  defp _dl_rows(data) do
    data |> Enum.map(&_dl_row/1)
  end

  defp _dl_row([dt_data, dd_data]) do
    [_dl_dt(dt_data), _dl_dd(dd_data)]
  end

  defp _dl_dt([content|options]) do
    _make_tag("dt", options, content) 
  end

  defp _dl_dd([content|options]) do
    _make_tag("dd", options, content) 
  end

  defp _make_tag(tag, options, content) do
    [_open_tag(tag, options), content, "</", tag, ">\n"]
  end

  defp _open_tag(tag, options) do
    ["<", tag, Enum.map(options, fn {attr, value} -> [" ", to_string(attr), ~s{="}, value, ~s{"}] end), ">"]
  end

end
