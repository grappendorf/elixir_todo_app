defmodule ElixirTodoApp.Router do
  use ElixirTodoApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirTodoApp do
    pipe_through :browser # Use the default browser stack

    get "/", AppController, :index
  end

  scope "/api", ElixirTodoApp do
    pipe_through :api

    resources "/todos", TodoController
    post "/todos/:id/states", TodoController, :create_states
  end
end
