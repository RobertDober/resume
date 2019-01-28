defmodule Resume.Composer do
  alias Resume.Cvs.Location

  def get_cv_config(cv) do
    with {:ok, yaml} <- YamlElixir.read_from_file(Location.path(cv, ["config.yml"])), do:
    yaml
  end

  def render(cv, name) do
    cond do
      Regex.match?(~r{\.md\z},name) -> render_md(cv, name)
      Regex.match?(~r{\.slime\z},name) -> render_slime(cv, name)
    end
  end
  defp render_md(cv, name) do
    content = File.read!(Location.path(cv, ["fragments", name]))
    {:safe, Earmark.as_html!(content)}
  end
  defp render_slime(cv, name) do
    content = File.read!(Location.path(cv, ["fragments", name]))
    {:safe, Slime.render(content, config: get_cv_config(cv), cv: cv)}
  end
end
