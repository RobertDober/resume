defmodule ResumeWeb.Router do
  use ResumeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", ResumeWeb do
    pipe_through :browser

    get "/", CvController, :index
    get "/cvs/:id/", CvController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ResumeWeb do
  #   pipe_through :api
  # end
end
