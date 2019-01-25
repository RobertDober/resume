defmodule ResumeWeb.CvController do
  use ResumeWeb, :controller
  alias Resume.Cvs

  def index(conn, _params) do
    render(conn, "index.html", cvs: Cvs.list)
  end

  def show(conn, %{"id" => id}) do
    cv = Cvs.find(id)
    yaml = Resume.Composer.get_cv(cv)
    render(conn, "show.html", yaml: yaml, cv: cv)
  end
  
end
