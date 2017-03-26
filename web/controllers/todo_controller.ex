defmodule ElixirTodoApp.TodoController do
  use ElixirTodoApp.Web, :controller
  alias ElixirTodoApp.{Repo, Todo, ErrorView, ClientChannel}

  def index conn, _params do
    todos = Todo |> Todo.latest_first |> Repo.all
    render conn, todos: todos
  end

  def show conn, %{"id" => id} do
    with {:ok, todo} <- load_model(Todo, id) do
      conn |> render(todo: todo)
    else
      {:error_load} ->
        conn |> put_status(:not_found) |> render(ErrorView, "404.json")
    end
  end

  def create conn, _ do
    with {:ok, todo} <- create_model(Todo.changeset %Todo{}, conn.body_params) do
      ClientChannel.publish_todo_created todo, conn.body_params["temp_id"]
      conn |> put_status(:created) |> json(%{id: todo.id})
    else
      {:error_create, errors} ->
        conn |> put_status(:bad_request) |> render_model_errors(errors)
    end
  end

  def update conn, %{"id" => id} do
    with {:ok, todo} <- load_model(Todo, id),
         {:ok, updated_todo} <- update_model Todo.changeset(todo, conn.body_params) do
         ClientChannel.publish_todo_updated updated_todo
         conn |> put_status(:no_content) |> json(nil)
    else
      {:error_load} -> conn |> put_status(:not_found) |> render(ErrorView, "404.json")
      {:error_update, errors} -> conn |> put_status(:bad_request) |> render_model_errors(errors)
    end
  end

  def delete conn, %{"id" => id} do
    with {:ok, todo} <- load_model(Todo, id),
         {:ok, _} <- delete_model(todo) do
         ClientChannel.publish_todo_deleted todo
         put_status(conn, :no_content) |> json(nil)
    else
      {:error_load} ->
        conn |> put_status(:not_found) |> render(ErrorView, "404.json")
      {:error_delete, errors} ->
        conn |> put_status(:bad_request) |> render_model_errors(errors)
    end
  end

  def create_states conn, %{"id" => id} do
    %{"status" => status} = conn.body_params
    with {:ok, todo} <- load_model(Todo, id),
         {:ok, updated_todo} <- update_model(Todo.changeset_for_states todo,
            %{status: String.to_existing_atom(status)}) do
         ClientChannel.publish_todo_updated updated_todo
         conn |> put_status(:no_content) |> json(nil)
    else
      {:error_load} ->
        conn |> put_status(:not_found) |> render(ErrorView, "404.json")
      {:error_update, errors} ->
        conn |> put_status(:bad_request) |> render_model_errors(errors)
    end
  end
end
