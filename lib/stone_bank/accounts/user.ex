defmodule StoneBank.Accounts.User do
  @moduledoc """
    User Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  @required_params [:email, :first_name, :last_name, :password, :password_confirmation, :role]

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "user"

    has_one :accounts, StoneBank.Accounts.Account

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, ~r/@/, message: "invalid format email")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password,
      min: 6,
      max: 100,
      message: "Password should have between 6 and 100 characters"
    )
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "There is an user with this email")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
