defmodule ElixirTodoApp.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use ElixirTodoApp.Web, :controller
      use ElixirTodoApp.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias ElixirTodoApp.Repo
      import Ecto
      import Ecto.Query

      import ElixirTodoApp.Router.Helpers
      import ElixirTodoApp.Gettext
      import ElixirTodoApp.ErrorHelpers
      import ElixirTodoApp.ModelHelpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import ElixirTodoApp.Router.Helpers
      import ElixirTodoApp.ErrorHelpers
      import ElixirTodoApp.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias ElixirTodoApp.Repo
      import Ecto
      import Ecto.Query
      import ElixirTodoApp.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
