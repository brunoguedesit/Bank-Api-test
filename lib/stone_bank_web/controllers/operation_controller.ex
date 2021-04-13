defmodule StoneBankWeb.OperationController do
  use StoneBankWeb, :controller
  alias StoneBank.Operations

  action_fallback StoneBankWeb.FallbackController

  def transfer(conn, %{"to_account_id" => t_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, message} <- Operations.transfer(user.accounts, t_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, message} <- Operations.withdraw(user.accounts, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def exchange(conn, %{"value" => value, "to_currency" => to_currency}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, message} <- Operations.exchange(user.accounts, value, to_currency) do
      conn
      |> render("success.json", message: message)
    end
  end

  def deposit(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, message} <- Operations.deposit(user.accounts, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def split_payment(conn, %{"to_accounts_id" => to_accounts_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, message} <- Operations.split_payment(user.accounts, to_accounts_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
