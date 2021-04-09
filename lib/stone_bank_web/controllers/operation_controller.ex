defmodule StoneBankWeb.OperationController do
  use StoneBankWeb, :controller
  alias StoneBank.Operations

  action_fallback StoneBankWeb.FallbackController

  def transfer(conn, %{"from_account_id" => f_id, "to_account_id" => t_id, "value" => value}) do
    with {:ok, message} <- Operations.transfer(f_id, t_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, %{"from_account_id" => f_id, "value" => value}) do
    with {:ok, message} <- Operations.withdraw(f_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
