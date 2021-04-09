defmodule StoneBank.Repo.Migrations.CreateTransactions do
  @moduledoc """
    Transactions migration
  """
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :money_with_currency
      add :account_from, :string
      add :account_to, :string
      add :type, :string
      add :date, :date

      timestamps()
    end
  end
end
