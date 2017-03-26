Code.require_file "#{__DIR__}/phoenix_helper.exs"

ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ElixirTodoApp.Repo)
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(ElixirTodoApp.Repo, [])
  end
end
