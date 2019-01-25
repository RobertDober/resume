defmodule Resume.Cvs do
  alias Resume.Cvs.CvLocation, as: Location


  def find(id) do
    {num_id, _} = Integer.parse(id)
    Enum.find(list, fn %{id: actual_id} -> actual_id == num_id end)
  end

  def list do
    [
      %Location{id: 1, version: "2.0.0", title: "Dev Lead Full Stack"},
      %Location{id: 2, version: "2.0.0", title: "Dev Lead Full Stack", lang: "en"},
    ]
  end
  
end
