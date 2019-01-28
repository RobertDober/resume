defmodule Resume.Composer do
  alias Resume.Cvs.Location

  def get_cv_config(cv) do
    with {:ok, yaml} <- YamlElixir.read_from_file(Location.path(cv, ["config.yml"])), do:
    yaml
  end
end
