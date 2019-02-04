defmodule Resume.Cvs do
  alias Resume.Cvs.Location

  def list do
    [
      %Location{lang: "fr", version: "2.0.0", title: "Dev Lead Full Stack"},
      %Location{version: "2.0.0", title: "Dev Lead Full Stack", lang: "en"},
    ]
  end
  
  def yaml(lang, version) do
    YamlElixir.read_all_from_file!(Path.join(["cvs", lang, version, "cv.yml"]))
  end
end
