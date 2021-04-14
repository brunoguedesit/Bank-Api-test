defmodule StoneBankWeb.TransactionTest do
  @moduledoc """
    Transaction controller test module
  """

  use StoneBank.DataCase
  use ExUnit.Case, async: true

  alias StoneBank.Transactions

  def create_transactions do
    [
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "deposit",
        date: ~D[2021-03-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "withdraw",
        date: ~D[2021-03-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "withdraw",
        date: ~D[2020-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "54321",
        type: "transfer",
        date: ~D[2021-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "exchange",
        date: ~D[2021-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "54321, 41234",
        type: "split_payment",
        date: ~D[2021-04-12]
      }
    ]
    |> Enum.map(fn transaction -> Transactions.create_transaction(transaction) end)
  end

  describe "transactions" do
    test "should insert a transactions" do
      transaction = %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        type: "transfer",
        account_to: "54321",
        date: ~D[2021-04-13]
      }

      result = Transactions.create_transaction(transaction)
      {:ok, transaction} = result
      assert Money.new(:BRL, "100") == transaction.value
    end

    test "should get a transaction" do
      transaction = %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        type: "transfer",
        account_to: "54321",
        date: ~D[2021-04-13]
      }

      {:ok, transaction} = Transactions.create_transaction(transaction)

      result = Transactions.get_transaction!(transaction.id)

      assert "#{transaction.id}" == Map.get(result, :id)
    end

    test "should update a transaction" do
      transaction = %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        type: "transfer",
        account_to: "54321",
        date: ~D[2021-04-13]
      }

      {:ok, transaction} = Transactions.create_transaction(transaction)

      {:ok, result} =
        Transactions.update_transaction(transaction, %{account_to: "nil", type: "withdraw"})

      assert "nil" == Map.get(result, :account_to)
      assert "withdraw" == Map.get(result, :type)
    end

    test "should delete a transaction" do
      transaction = %{
        value: Money.new(:BRL, "100"),
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2021-04-13]
      }

      {:ok, transaction} = Transactions.create_transaction(transaction)

      {:ok, result} = Transactions.delete_transaction(transaction)

      assert "#{transaction.id}" == Map.get(result, :id)
    end

    test "should return all transactions" do
      create_transactions()
      transactions = Transactions.all()

      assert transactions.total == %Money{currency: :BRL, amount: Decimal.new(600)}
      assert Enum.count(transactions.transactions) == 6
    end

    test "should return all transactions by year" do
      create_transactions()
      transactions = Transactions.year(2021)

      assert transactions.total == %Money{currency: :BRL, amount: Decimal.new(500)}
      assert Enum.count(transactions.transactions) == 5
    end

    test "should return all transactions by month" do
      create_transactions()
      transactions = Transactions.month(2021, 04)

      assert transactions.total == %Money{currency: :BRL, amount: Decimal.new(300)}
      assert Enum.count(transactions.transactions) == 3
    end

    test "should return all transactions by day" do
      create_transactions()
      transactions = Transactions.day("2021-04-13")

      assert transactions.total == %Money{currency: :BRL, amount: Decimal.new(200)}
      assert Enum.count(transactions.transactions) == 2
    end
  end
end
