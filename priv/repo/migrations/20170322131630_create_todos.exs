defmodule ElixirTodoApp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table :todos do
      add :text, :string
      add :status, :integer, default: 0
      timestamps()
    end
  end
end
