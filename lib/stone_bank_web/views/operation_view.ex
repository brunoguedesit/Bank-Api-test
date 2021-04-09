defmodule StoneBankWeb.OperationView do
  use StoneBankWeb, :view

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end
end
