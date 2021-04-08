defmodule StoneBankWeb.OperationView do
  use StoneBankWeb, :view

  def render("sucess.json", %{message: message}) do
    %{
      message: message
    }
  end
end
