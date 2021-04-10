defmodule StoneBank.Operations do
  @moduledoc """
    contains the operations of the bank
  """

  @withdraw "withdraw"
  @transfer "transfer"

  alias StoneBank.{Accounts, Accounts.Account}
  alias StoneBank.Repo
  alias StoneBank.Transactions.Transaction

  def withdraw(f_id, value) do
    from = Accounts.get!(f_id)
    value = Money.new(:brl, value)

    validate_negative(from.amount, value, withdraw_operation(from, value))
  end

  defp validate_negative(amount, value, operation) do
    case is_negative_amount(amount, value) do
      true ->
        {:error, "you can't have negative amount!"}

      false ->
        operation
    end
  end

  defp withdraw_operation(from, value) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.insert(:transaction, gen_transaction(value, from.id, nil, @withdraw))
    |> Repo.transaction()
    |> transaction_case("Withdraw with success!!! from: #{from.id} value: #{value}")
  end

  def transfer(f_id, t_id, value) do
    from = Accounts.get!(f_id)
    value = Money.new(:brl, value)

    validate_negative(from.amount, value, perform_update(from, t_id, value))
  end

  defp is_negative_amount(from_amount, value) do
    {:ok, %Money{currency: _, amount: value_in_money}} = Money.sub(from_amount, value)
    Decimal.negative?(value_in_money)
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

  def update_account(%Account{} = account, params) do
    Account.changeset(account, params)
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
