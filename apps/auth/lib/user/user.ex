defmodule Auth.User do
  use Storage.Schema

  alias __MODULE__

  @type t :: %__MODULE__{
          email: String.t(),
          password: String.t(),
          password_hash: String.t()
        }

  @fields [:email, :password, :password_hash]
  @required_fields [:email, :password]

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  defp create_changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_email()
    |> validate_password()
    |> handle_password()
  end

  defp validate_email(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp validate_email(changeset) do
    validation_regex =
      ~r/(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/

    changeset
    |> validate_format(:email, validation_regex, message: "Incorrect email format.")
  end

  defp validate_password(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp validate_password(changeset) do
    validation_regex =
      ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&\.,])[A-Za-z\d@$!%*?&\.,]{8,}$/

    changeset
    |> validate_format(:password, validation_regex,
      message:
        "Password should contain a minimum of eight characters, at least one uppercase, one lowercase, one number and one special character."
    )
  end

  defp handle_password(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp handle_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:password_hash, Pbkdf2.hash_pwd_salt(password))
  end

  @spec create(CreateCommand.t()) :: {:ok, %__MODULE__{}} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> create_changeset()
    |> Storage.Repo.insert()
  end
end
