defmodule ElixirTodoApp.TodoFactory do
  use ExMachina.Ecto, repo: ElixirTodoApp.Repo
  alias ElixirTodoApp.Todo

  def todo_factory do
    %Todo{
      text: sequence(:todo_text, &"Todo-#{&1}"),
      status: :todo
    }
  end
end
