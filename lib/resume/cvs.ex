defmodule Resume.Cvs do

  def list do
    [
      %{lang: "fr", version: "2.0.0", title: "Dev Lead Full Stack"},
      %{version: "2.0.0", title: "Dev Lead Full Stack", lang: "en"},
      %{version: "2.0.1", title: "Dev Lead Full Stack -- detailed", lang: "fr", template: "detailed"},
    ]
  end
  
  def yaml(lang, version) do
    YamlElixir.read_all_from_file!(Path.join(["cvs", lang, version, "cv.yml"]))
  end
end
