import Config

config :storage, ecto_repos: [Storage.Repo]

config :storage, Storage.Repo,
  database: "messenger",
  username: "postgres",
  password: "",
  hostname: "localhost",
	pool: Ecto.Adapters.SQL.Sandbox
