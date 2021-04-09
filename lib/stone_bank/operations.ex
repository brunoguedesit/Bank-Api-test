defmodule StoneBank.Operations do
  @moduledoc """
    contains the operations of the bank
  """

  alias StoneBank.{Accounts, Accounts.Account}
  alias StoneBank.Repo

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
    {:ok, from} = perform_operation(from, value, :sub)
    {:ok, to} =
      Accounts.get!(t_id)
      |> perform_operation(value, :sum)
    {:ok, "Transfer with sucess!! from: #{from.id} to: #{to.id} value: #{value}"}
  end

  defp perform_operation(account, value, :sub) do
    {:ok, value_response_sub } = Money.sub(account.amount, value)
    update_account(account, %{amount: value_response_sub})
  end

  defp perform_operation(account, value, :sum) do
    {:ok, value_response_sum } = Money.add(account.amount, value)
    update_account(account, %{amount: value_response_sum})
  end

  def update_account(%Account{} = account, params) do
    Account.changeset(account, params)
    |> Repo.update()
  end
end
