defmodule ElixirTodoApp.Repo do
  use Ecto.Repo, otp_app: :elixir_todo_app

  def count query do
    query |> aggregate(:count, :id)
  end
end
