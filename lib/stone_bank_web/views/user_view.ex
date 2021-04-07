defmodule StoneBankWeb.UserView do
  use StoneBankWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      amount: account.amount,
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
end
