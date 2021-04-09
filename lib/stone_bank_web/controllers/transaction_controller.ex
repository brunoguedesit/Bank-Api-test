defmodule StoneBankWeb.TransactionController do
  use StoneBankWeb, :controller

  action_fallback StoneBankWeb.FallbackController

  def all(conn, _) do
    render(conn, "show.json", transaction: Transactions.all())
  end

  def year(conn, _) do
    render(conn, "show.json", transaction: Transactions.year(year))
  end

  def month(conn, _) do
    render(conn, "show.json", transaction: Transactions.month(year, month))
  end

  def day(conn, _) do
    render(conn, "show.json", transaction: Transactions.day(day))
  end
end
