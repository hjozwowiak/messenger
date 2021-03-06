defmodule Storage.MixProject do
  use Mix.Project

  def project do
    [
      app: :storage,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Storage.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.7"},
      {:postgrex, "~> 0.16.1"}
    ]
  end
end
