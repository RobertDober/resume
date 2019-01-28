defmodule Resume.Cvs do
  alias Resume.Cvs.Location


  def find(lang, version) do
    Enum.find(list, fn 
      %{lang: ^lang, version: ^version} -> true
      _                                 -> false
    end)
  end

  def list do
    [
      %Location{lang: "fr", version: "2.0.0", title: "Dev Lead Full Stack"},
      %Location{version: "2.0.0", title: "Dev Lead Full Stack", lang: "en"},
    ]
  end
  
end
