defmodule ElixirTodoApp.ClientChannel do
  use Phoenix.Channel
  require Logger
  alias ElixirTodoApp.Endpoint

  def join "client", _, socket do
    {:ok, socket}
  end

  def publish_todo_created todo, temp_id do
    Endpoint.broadcast("client", "action", %{
      action: :todo_was_created, params: [temp_id, todo.id, todo.text, todo.status]})
  end

  def publish_todo_updated todo do
    Endpoint.broadcast("client", "action", %{
      action: :todo_was_updated, params: [todo.id, todo.text, todo.status]})
  end

  def publish_todo_deleted todo do
    Endpoint.broadcast("client", "action", %{
      action: :todo_was_deleted, params: [todo.id]})
  end
end
