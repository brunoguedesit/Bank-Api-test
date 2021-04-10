defmodule StoneBank.Transactions do
  @moduledoc """
    a module to get a list of transactions reports
  """

  import Ecto.Query, warn: false

  alias StoneBank.Repo
  alias StoneBank.Transactions.Transaction

  def all do
    Repo.all(Transaction)
    |> create_payload()
  end

  def year(year) do
    year = String.to_integer(year)
    start_date = Date.from_erl!({year, 01, 01})
    end_date = Date.from_erl!({year, 12, 31})
    query = from t in Transaction, where: t.date >= ^start_date and t.date <= ^end_date

    Repo.all(query)
    |> create_payload()
  end

  def month(year, month) do
    year = String.to_integer(year)
    month = String.to_integer(month)
    start_date = Date.from_erl!({year, month, 01})
    days_in_month = start_date |> Date.days_in_month()
    end_date = Date.from_erl!({year, month, days_in_month})
    query = from t in Transaction, where: t.date >= ^start_date and t.date <= ^end_date

    Repo.all(query)
    |> create_payload()
  end

  def day(date) do
    query = from t in Transaction, where: t.date >= ^Date.from_iso8601!(date)

    Repo.all(query)
    |> create_payload()
  end

  def create_payload(transactions) do
    %{transactions: transactions, total: calculate_value(transactions)}
  end

  def calculate_value(transactions) do
    # {:ok,  value } = Money.new(:BRL, "0")
    Enum.reduce(transactions, Money.new(:BRL, "0"), fn t, acc ->
      Money.add!(t.value, acc)
    end)
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def create_transaction(params \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end

  def update_transaction(%Transaction{} = transaction, params) do
    transaction
    |> Transaction.changeset(params)
    |> Repo.update()
  end

  def delete_transaction(%Transaction{} = transaction) do
    transaction
    |> Repo.delete()
  end
end
