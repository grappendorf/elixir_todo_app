use Mix.Config

config :elixir_todo_app, ElixirTodoApp.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :elixir_todo_app, ElixirTodoApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "elixir_todo_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
