defmodule ElixirTodoApp.ErrorView do
  use ElixirTodoApp.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("401.json", _conn) do
    %{error: %{message: "Invalid credentials"}}
  end

  def render("404.json", _conn) do
    %{errors: %{detail: "Not found"}}
  end

  def render("500.json", _conn) do
    %{errors: %{detail: "Internal server error"}}
  end

  def template_not_found(_template, conn) do
    render "500.json", conn
  end
end
