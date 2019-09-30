defmodule ResumeWeb.CvController do
  use ResumeWeb, :controller
  alias Resume.Cvs

  def index(conn, _params) do
    render(conn, "index.html", cvs: Cvs.list, title: "List of available CVs")
  end

  def show(conn, %{"lang" => lang, "version" => version, "renderer" => renderer}) do
    config = Cvs.config(lang, version) |> hd()
    name_for_title =
      config
      |> Map.get("name")
      |> String.replace(" ", "")

    yaml = Cvs.yaml(lang, version) |> hd()
    conn
    # |> put_layout(false)
    |> render("show.html", composer: Resume.Composer, cv: yaml, title: "CV-#{name_for_title}-#{lang}-#{version}", renderer: renderer )
    # |> render("#{renderer}/show.html", composer: Resume.Composer, cv: yaml, title: "CV-#{name_for_title}-#{lang}-#{version}", renderer: renderer )
  end

  def template(conn, %{"lang" => lang, "version" => version, "template" => template}) do
    yaml = Cvs.yaml(lang, version) |> hd()
    conn
    |> render("#{template}.html", composer: Resume.Composer, cv: yaml )
  end

  
end
