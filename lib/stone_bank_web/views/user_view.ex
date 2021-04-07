defmodule StoneBankWeb.UserView do
  use StoneBankWeb, :view

  def render("account.json", %{account: account}) do
    %{
      amount: account.amount,
      account_id: account.id,
      user: %{
        email: account.user.email,
        first_name: account.user.first_name,
        last_name: account.user.last_name,
        role: account.user.roke,
        id: account.user.id
      }
    }
  end
end
