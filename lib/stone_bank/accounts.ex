defmodule StoneBank.Accounts do
  @moduledoc """
    a module for insert users accounts at database
  """

  alias StoneBank.Accounts.{Account, User}
  alias StoneBank.Repo

  def create_user(params \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, insert_user(params))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        user
        |> Ecto.build_assoc(:accounts)
        |> Account.changeset()
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, operations} -> {:ok, operations.user, operations.account}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  defp insert_user(params) do
    %User{}
    |> User.changeset(params)
  end
end
