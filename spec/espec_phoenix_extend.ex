defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias ElixirTodoApp.Repo
    end
  end

  def controller do
    quote do
      alias ElixirTodoApp
      import ElixirTodoApp.Router.Helpers

      @endpoint ElixirTodoApp.Endpoint
    end
  end

  def view do
    quote do
      import ElixirTodoApp.Router.Helpers
    end
  end

  def channel do
    quote do
      alias ElixirTodoApp.Repo

      @endpoint ElixirTodoApp.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
