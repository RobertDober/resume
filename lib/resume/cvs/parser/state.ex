defmodule Resume.Cvs.Parser.State do
  defstruct [
    indent: 0,
    state: :new,
    key: nil,
    container: %{},
    errors: [] ]

   @moduledoc """
   A struct for the parser
   """

end
