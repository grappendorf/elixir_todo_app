use Mix.Config

config :elixir_todo_app, ElixirTodoApp.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

config :elixir_todo_app, ElixirTodoApp.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :elixir_todo_app, ElixirTodoApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "elixir_todo_app_dev",
  hostname: "localhost",
  pool_size: 10
