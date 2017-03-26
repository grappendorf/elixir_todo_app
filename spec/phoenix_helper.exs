Code.require_file("spec/espec_phoenix_extend.ex")

Ecto.Adapters.SQL.Sandbox.mode(ElixirTodoApp.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
