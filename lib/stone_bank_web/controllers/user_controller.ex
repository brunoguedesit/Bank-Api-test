defmodule StoneBankWeb.UserController do
  use StoneBankWeb, :controller
  alias StoneBank.Accounts

  action_fallback StoneBankWeb.FallbackController

  def signup(conn, %{"user" => user}) do
    with {:ok, user, account} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> render("account.json", %{user: user, account: account})
    end
  end
end
