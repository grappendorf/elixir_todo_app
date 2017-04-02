defmodule Client do
  alias Client.{Middlewares, Reducers, Store, Todo, Views}

  def start _, _ do
    create_store()
    |> add_middlewares()
    |> add_reducers()
    |> add_subscribers()
    |> start_store()
    |> dispatch_initial_actions()
  end

  def create_store do
    initial_state = %{
      todos: [],
      new_todo_text: "",
      edit_todo: nil,
      hide_done: false,
      tutor: :done,
      config: %{}
    }
    json_state = JSON.parse(:document.getElementById("state").innerHTML)
    Store.new(case json_state do
      nil -> initial_state
      json -> Map.merge initial_state, %{
        todos: Enum.map(json_state["todos"], &(Todo.new_from_json &1)),
        config: JSON.parse :document.getElementById("config").innerHTML
      }
    end)
  end

  def add_middlewares store do
    store
    |> Store.middleware(&Middlewares.tutor/4)
    |> Store.middleware(&Middlewares.api/4)
  end

  def add_reducers store do
    store |> Store.reduce(&Reducers.reduce/2)
  end

  def add_subscribers store do
    store |> Store.subscribe(&Views.render/2)
  end

  def start_store store do
    store |> Store.start()
  end

  def dispatch_initial_actions store do
    dispatch store, {:start_tutor}
  end

  def dispatch store, action do
    Store.dispatch action
    store
  end
end
