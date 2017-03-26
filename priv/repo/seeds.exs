alias ElixirTodoApp.{Repo, Todo}

Repo.insert! Todo.changeset(%Todo{},
  %{text: "Welcome to the Elxir Todo App! Please take the tutorial tour."})
