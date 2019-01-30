defmodule ResumeWeb.CvController do
  use ResumeWeb, :controller
  alias Resume.Cvs

  def index(conn, _params) do
    render(conn, "index.html", cvs: Cvs.list)
  end

  def show(conn, %{"lang" => lang, "version" => version}) do
    cv = Cvs.find(lang, version)
    conn
    # |> put_layout(false)
    |> render("show.html", composer: Resume.Composer, cv: cv )
  end
  
end
