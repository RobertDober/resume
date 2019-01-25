defmodule Resume.Composer do
  
  def get_cv(cv) do
    with {:ok, yaml} <- YamlElixir.read_from_file(Path.join(["assets", "cvs", to_string(cv.id), "cv.yml"])), do:
      yaml
  end
end
