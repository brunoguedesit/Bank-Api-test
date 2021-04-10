defmodule StoneBank.Accounts.Auth.Session do
  @moduledoc """
    a module to get a auth session
  """

  import Ecto.Query, warn: false
  alias StoneBank.Accounts.User
  alias StoneBank.Repo

  def authenticate(email, password) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, :not_found}

      user ->
        if Comeonin.Argon2.checkpw(password, user.password_hash) do
          {:ok, user |> Repo.preload(:accounts)}
        else
          {:error, :unauthorized}
        end
    end
  end
end
