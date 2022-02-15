defmodule Auth.User do
	use Storage.Schema
  use Storage.Service

  alias __MODULE__

  @type t :: %__MODULE__{
		email: String.t(),
		password_hash: String.t()
	}

  schema "users" do
		field(:email, :string)
    field(:password_hash, :string)

    timestamps()
  end	
end
