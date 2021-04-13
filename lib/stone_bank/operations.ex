defmodule StoneBank.Operations do
  @moduledoc """
    contains the operations of the bank
  """

  @withdraw "withdraw"
  @transfer "transfer"
  @exchange "exchange"
  @deposit "deposit"
  @split_payment "split_payment"

  alias StoneBank.{Accounts, Accounts.Account}
  alias StoneBank.Repo
  alias StoneBank.Transactions.Transaction

  def withdraw(from, value) do
    value = Money.new(:brl, value)

    case is_negative_amount?(from.amount, value) do
      true ->
        {:error, "you can't have negative amount!"}

      false ->
        withdraw_operation(from, value)
    end
  end

  defp withdraw_operation(from, value) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, nil, @withdraw))
    |> Repo.transaction()
    |> transaction_case("Withdraw with success!!! from: #{from.id} value: #{value}")
  end

  def transfer(from, t_id, value) do
    value = Money.new(:brl, value)

    case is_negative_amount?(from.amount, value) do
      true -> {:error, "you can't have negative amount!"}
      false -> perform_update(from, t_id, value)
    end
  end

  def exchange(from, value, to_currency) do
    value = Money.new(:brl, value)

    case is_negative_amount?(from.amount, value) do
      true ->
        {:error, "you can't have negative amount!"}

      false ->
        exchange_operation(from, value, to_currency)
    end
  end

  defp exchange_operation(from, value, to_currency) do
    {:ok, exchange_value} = Money.to_currency(value, to_currency)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :exchange))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, nil, @exchange))
    |> Repo.transaction()
    |> transaction_case(
      "exchange with success!!! from: #{from.id} value: #{value} converted to: #{exchange_value}"
    )
  end

  def deposit(from, value) do
    value = Money.new(:brl, value)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sum))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, nil, @deposit))
    |> Repo.transaction()
    |> transaction_case("deposit with success!!! from: #{from.id} value: #{value}")
  end

  def split_payment(from, to_accounts_id, value) do
    value = Money.new(:brl, value)

    case is_negative_amount?(from.amount, value) do
      true ->
        {:error, "you can't have negative amount!"}

      false ->
        perform_operation(to_accounts_id, value, :split_payment)
        split_payment_operation(from, to_accounts_id, value)
    end
  end

  defp split_payment_operation(from, to_accounts_id, value) do
    to_accounts =
      to_accounts_id
      |> Enum.map(&to_string/1)
      |> Enum.join(", ")

    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.insert(
      :transaction,
      gen_transaction(value, from.id, to_accounts, @split_payment)
    )
    |> Repo.transaction()
    |> transaction_case(
      "split payment with success!!! from: #{from.id} to: #{to_accounts} value: #{value}"
    )
  end

  defp perform_update(from, t_id, value) do
    to = Accounts.get!(t_id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.update(:account_to, perform_operation(to, value, :sum))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, to.id, @transfer))
    |> Repo.transaction()
    |> transaction_case("Transfer with success!!! from: #{from.id} to: #{to.id} value: #{value}")
  end

  defp transaction_case(operations, msg) do
    case operations do
      {:ok, _} -> {:ok, msg}
      {:error, :account_from, changeset, _} -> {:error, changeset}
      {:error, :account_to, changeset, _} -> {:error, changeset}
      {:error, :transaction, changeset, _} -> {:error, changeset}
    end
  end

  defp perform_operation(account, value, :sub) do
    {:ok, value_response_sub} = Money.sub(account.amount, value)
    update_account(account, %{amount: value_response_sub})
  end

  defp perform_operation(account, value, :sum) do
    {:ok, value_response_sum} = Money.add(account.amount, value)
    update_account(account, %{amount: value_response_sum})
  end

  defp perform_operation(account, value, :exchange) do
    {:ok, value_response_sub} = Money.sub(account.amount, value)
    update_account(account, %{amount: value_response_sub})
  end

  defp perform_operation(accounts, value, :split_payment) do
    Enum.map(accounts, fn ids ->
      x = Accounts.get!(ids)
      acc = Money.new(:brl, "0")

      accounts_number = Enum.count(accounts)
      {:ok, splited_value} = Money.div(Money.add!(acc, value), accounts_number)
      value_response_sum = Money.add!(x.amount, splited_value)

      update_account(x, %{amount: value_response_sum})
      |> Repo.update()
    end)
  end

  def update_account(%Account{} = account, params) do
    Account.changeset(account, params)
  end

  defp is_negative_amount?(from_amount, value) do
    {:ok, %Money{currency: _, amount: value_in_money}} = Money.sub(from_amount, value)
    Decimal.negative?(value_in_money)
  end

  defp gen_transaction(value, f_id, t_id, type) do
    %Transaction{
      value: value,
      account_from: f_id,
      account_to: t_id,
      type: type,
      date: Date.utc_today()
    }
  end
end
