defmodule ElixirTodoApp.TodoView do
  use ElixirTodoApp.Web, :view

  def render "index.json", %{todos: todos} do
    todos |> Enum.map(&todo_to_json/1)
  end

  def render "show.json", %{todo: todo} do
    todo_to_json todo
  end

  defp todo_to_json todo do
    %{
      id: todo.id,
      text: todo.text,
      status: todo.status
    }
  end
end
