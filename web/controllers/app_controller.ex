defmodule ElixirTodoApp.AppController do
  use ElixirTodoApp.Web, :controller
  alias ElixirTodoApp.{Repo, Todo, TodoView}

  def index conn, _params do
    config = create_config()
    todos = Todo |> Todo.latest_first |> Repo.all |> Enum.map(&TodoView.todo_to_json/1)
    store = Client.create_store()
      |> add_config_to_store(config)
      |> Client.add_reducers()
      |> Client.Store.dispatch({:load_todos, todos})
    render conn, "index.html", dom: render_page(store),
      config: config,
      state: Client.Store.state(store)
  end

  defp create_config do
    %{
      version: Application.get_env(:elixir_todo_app, :version)
    }
  end

  defp add_config_to_store store = %{state: state}, config do
    %Client.Store{state: Map.put(state, :config, config)}
  end

  def render_page store do
    store |> Client.Store.state |> Client.Views.page
  end
end
