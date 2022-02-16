defmodule Storage.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Storage.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Storage.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Storage.Repo, {:shared, self()})
    end

    :ok
  end
end
