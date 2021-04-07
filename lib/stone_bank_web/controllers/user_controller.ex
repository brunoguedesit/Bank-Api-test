defmodule StoneBankWeb.UserController do
  use StoneBankWeb, :controller
  alias StoneBank.Accounts

  def signup(conn, %{"user" => user}) do
    {:ok, user, account} = Accounts.create_user(user)

    conn
    |> put_status(:created)
    |> render("account.json", %{user: user, account: account})
  end
end
