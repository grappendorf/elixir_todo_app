defmodule ElixirTodoApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ElixirTodoApp.Repo, []),
      supervisor(ElixirTodoApp.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: ElixirTodoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ElixirTodoApp.Endpoint.config_change(changed, removed)
    :ok
  end
end
