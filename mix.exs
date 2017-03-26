defmodule ElixirTodoApp.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_todo_app,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext, :elixir_script] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     preferred_cli_env: [espec: :test],
     elixir_script: [
       input: ["web/static/exjs", "lib/shared"],
       output: "web/static/js/build",
       format: :es,
       js_modules: [
         {React, "react"},
         {ReactDOM, "react-dom"},
         {ReactCSSTransitionGroup, "react-addons-css-transition-group"},
         {ModalVanilla, "modal-vanilla"},
         {Phoenix, "phoenix", default: false}
       ]
     ]]
  end

  def application do
    [mod: {ElixirTodoApp, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "spec/factories"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2.3"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:elixir_script, "~> 0.27.0"},
      {:fs, "~> 2.12.0", override: true},
      {:ecto_enum, "~> 1.0.1"},
      {:espec_phoenix, "~> 0.6.8", only: :test},
      {:test_that_json_espec, "~> 0.6.0"},
      {:ex_machina, "~> 2.0.0", only: :test}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "specs": ["espec"],
     "test": ["ecto.create --quiet", "ecto.migrate", "espec"]]
  end
end
