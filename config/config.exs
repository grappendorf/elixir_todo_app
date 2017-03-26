use Mix.Config

config :elixir_todo_app,
  ecto_repos: [ElixirTodoApp.Repo],
  version: "0.0.1"

config :elixir_todo_app, ElixirTodoApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "elHILQhViEfvCEEj1BgAJjYeIveTbn/jSIvjQ+JKkAaYqWDQZ3yC8Bj9ezbIaBrH",
  render_errors: [view: ElixirTodoApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirTodoApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
