defmodule Resume.Cvs.Location do
  defstruct [lang: "fr", version: "0.0.0", title: "My CV", url: ""]

  def path(cv, segments) do
    Path.join(["cvs", cv.lang, cv.version, "fragments", segments])
  end

  def wildcard(cv, pattern) do
    ["cvs", cv.lang, cv.version, "fragments", pattern]
    |> Path.join
    |> Path.wildcard
    |> Enum.reverse
  end

end
