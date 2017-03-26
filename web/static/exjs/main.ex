defmodule Main do
  def start _, _ do
    create_store()
    |> Store.middleware(&Middlewares.tutor/4)
    |> Store.middleware(&Middlewares.api/4)
    |> Store.reduce(&Reducers.reduce/2)
    |> Store.subscribe(&Views.render/2)
    |> Store.start

    Store.dispatch {:load_todos}
    Store.dispatch {:start_tutor}
  end

  def create_store do
    Store.new %{
      todos: [],
      new_todo_text: "",
      edit_todo: nil,
      hide_done: false,
      tutor: :done,
      config: JSON.parse :document.getElementById("config").innerHTML
    }
  end
end
