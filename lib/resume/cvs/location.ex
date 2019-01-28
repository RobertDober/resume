defmodule Resume.Cvs.Location do
  defstruct [lang: "fr", version: "0.0.0", title: "My CV", url: ""]

  def path(cv, segments \\ []) do
    Path.join(["cvs", cv.lang, cv.version | segments])
  end
  
end
