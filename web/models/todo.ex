defmodule ElixirTodoApp.Todo do
  use ElixirTodoApp.Web, :model
  alias ElixirTodoApp.{Repo}
  import EctoEnum, except: [cast: 3]

  defenum Status, todo: 0, done: 1

  schema "todos" do
    field :text, :string
    field :status, Status, default: :todo
    timestamps
  end

  def changeset todo, params \\ %{} do
    todo
    |> cast(params, [:text, :status])
    |> validate_required([:text])
  end

  def changeset_for_states todo, params \\ %{} do
    todo
    |> cast(params, [:status])
    |> validate_required([:status])
  end

  def latest_first todos do
    from todo in todos,
    order_by: [desc: todo.inserted_at]
  end
end
