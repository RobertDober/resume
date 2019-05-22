defmodule Resume.Cvs do

  def list do
    _configured_cvs()
  end
  
  def yaml(lang, version) do
    YamlElixir.read_all_from_file!(Path.join(["cvs", lang, version, "cv.yml"]))
  end

  defp _configured_cvs do
    Path.wildcard("cvs/fr/**/config.yml") 
    |> Enum.map(&{&1, YamlElixir.read_from_file!(&1)
    |> Map.get("title")}) 
    |> Enum.reject(fn {_, nil} -> true; _ -> false end)
    |> Enum.map(&_extract_values/1)
  end

  defp _extract_lang_version(path) do
    path
    |> String.split("/")
    |> Enum.slice(1, 2)
  end

  defp _extract_values({path, title}) do
    [ lang, version ] = _extract_lang_version(path)
    %{lang: lang, version: version, title: title}
  end
  
end
