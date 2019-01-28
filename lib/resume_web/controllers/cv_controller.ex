defmodule ResumeWeb.CvController do
  use ResumeWeb, :controller
  alias Resume.Cvs

  def index(conn, _params) do
    render(conn, "index.html", cvs: Cvs.list)
  end

  def show(conn, %{"lang" => lang, "version" => version}) do
    cv = Cvs.find(lang, version)
    config = Resume.Composer.get_cv_config(cv)  |> IO.inspect
    render(conn, "show.html", config: config, cv: cv)
  end
  
end
