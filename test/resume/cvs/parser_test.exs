defmodule Resume.Cvs.ParserTest do
  use ExUnit.Case

  alias Resume.Cvs.Parser, as: P
  doctest P

  test "empty" do
    result = P.parse("")

    assert result == {:ok, %{}, []}
  end
end
