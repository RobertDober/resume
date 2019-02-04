defmodule Resume.Cvs.Parser do

  alias Resume.Cvs.Parser.State

  @moduledoc """
  A simple content description format paser with very simple rules

  * One item per line

  * Strict two space alignment for structure
  """

  @doc """
    iex> lines= [ "head:", "   name:", "    Robert", "  dob:", "    Not your business"]
    ...> Resume.Cvs.Parser.parse(lines)
    %{head: %{name: "Robert", dob: "Not your business"}}
  """
  def parse(lines)
  def parse(lines) when is_binary(lines) do
    lines
    |> String.split(~r{\n\r?})
    |> _parse_lines()
  end
  def parse(lines) do
    lines
    |> _parse_lines()
  end


  defp _add_tag(result_and_errors)
  defp _add_tag({result, []}), do: {:ok, result, []}
  defp _add_tag({result, errors}), do: {:error, result, errors}

  @indent_rgx ~r{\A(\s*)(.*)}
  defp _get_indent(line) do
    [_, prefix, rest] = Regex.run(@indent_rgx, line)
    indent = String.length(prefix)
    case :erlang.rem(indent, 2) do
      0 -> {:ok, indent, rest}
      x -> {:error, "illegal indent #{x}"}
    end
  end

  defp _match(rgx, line) do
    case Regex.run(rgx, line) do
      [match] -> match
      _       -> false
    end
  end

  defp _parse_kwd(kwd, {line, lnb, curr_indent}, rest, state) do
  end
  defp _parse_many(lines, state)
  defp _parse_many([], state), do: {state.container, state.errors}
  defp _parse_many([{line, lnb}|rest], state), do: _parse_one({line, lnb}, rest, state)

  defp _parse_one({line, lnb}, rest, state) do
    case _get_indent(line) do
      {:ok, new_indent, rol} -> _parse_with_indent({rol, lnb, new_indent}, rest, state)
      {:error, message} -> %{state | errors: [{lnb, message}|state.errors]}
    end
  end

  @kwd_rgx ~r{\A[\w-]+:}
  @empty_rgx ~r{\A\s*\z}
  defp _parse_with_indent({line, _, _}=input, rest, state) do
    cond do
      match = _match(@kwd_rgx, line) -> _parse_kwd(match, input, rest, state)
      # _match(@empty_rgx, line)       -> _parse_empty(input, rest, state)
      # true                           -> _parse_data(input, rest, state)
    end
  end



  defp _parse_lines(lines) do
    lines
    |> Enum.zip(Stream.iterate(1, &(&1 + 1)))
    |> _parse_many(struct(State))
    |> _add_tag()
  end
end
