defmodule StoneBank.Accounts do
  @moduledoc """
    a module for insert users accounts at database
  """

  alias StoneBank.Accounts.{Account, User}
  alias StoneBank.Repo

  def create_user(params \\ %{}) do
    case insert_user(params) do
      {:ok, user} ->
        {:ok, account} =
          user
          |> Ecto.build_assoc(:accounts)
          |> Account.changeset()
          |> Repo.insert()

        {:ok, account |> Repo.preload(:user)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp insert_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
