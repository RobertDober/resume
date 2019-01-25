defmodule ResumeWeb.PageController do
  use ResumeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
