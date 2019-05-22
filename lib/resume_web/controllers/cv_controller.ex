defmodule ResumeWeb.CvController do
  use ResumeWeb, :controller
  alias Resume.Cvs

  def index(conn, _params) do
    render(conn, "index.html", cvs: Cvs.list)
  end

  def show(conn, %{"lang" => lang, "version" => version}) do
    yaml = Cvs.yaml(lang, version) |> hd()
    conn
    # |> put_layout(false)
    |> render("show.html", composer: Resume.Composer, cv: yaml )
  end

  def template(conn, %{"lang" => lang, "version" => version, "template" => template}) do
    yaml = Cvs.yaml(lang, version) |> hd()
    conn
    |> render("#{template}.html", composer: Resume.Composer, cv: yaml )
  end

  
end
