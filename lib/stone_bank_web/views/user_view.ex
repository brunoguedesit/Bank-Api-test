defmodule StoneBankWeb.UserView do
  use StoneBankWeb, :view

  def render("user.json", %{user: user}) do
    user
  end
end
