defmodule StoneBankWeb.UserView do
  use StoneBankWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      balance: account.amount,
      account_id: account.id,
      user: %{
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        role: user.role,
        id: user.id
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      role: user.role,
      accounts: %{
        id: user.accounts.id,
        balance: user.accounts.amount
      }
    }
  end
end
