defmodule StoneBank.Operations do
  @moduledoc """
    contains the operations of the bank
  """

  alias StoneBank.{Accounts, Accounts.Account}
  alias StoneBank.Repo

  def withdraw(f_id, value) do
    from = Accounts.get!(f_id)
    value = Money.new(:brl, value)

    case is_negative_amount(from.amount, value) do
      true ->
        {:error, "you can't have negative amount!"}

      false ->
        {:ok, from} = perform_operation(from, value, :sub) |> Repo.update()
        {:ok, "Withdraw with success!!! from: #{from.id}, value: #{value}"}
    end
  end

  def transfer(f_id, t_id, value) do
    from = Accounts.get!(f_id)
    value = Money.new(:brl, value)

    case is_negative_amount(from.amount, value) do
      true -> {:error, "you can't have negative amount!"}
      false -> perform_update(from, t_id, value)
    end
  end

  defp is_negative_amount(from_amount, value) do
    {:ok, %Money{currency: _, amount: value_in_money}} = Money.sub(from_amount, value)
    Decimal.negative?(value_in_money)
  end

  defp perform_update(from, t_id, value) do
    to = Accounts.get!(t_id)

    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
      |> Ecto.Multi.update(:account_to, perform_operation(to, value, :sum))
      |> Repo.transaction()

    case transaction do
      {:ok, _} -> {:ok, "Transfer with sucess!! from: #{from.id} to: #{to.id} value: #{value}"}
      {:error, :account_from, changeset, _} -> {:error, changeset}
      {:error, :account_to, changeset, _} -> {:error, changeset}
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
end
