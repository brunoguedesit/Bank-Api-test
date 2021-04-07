defmodule StoneBank.Repo.Migrations.CreateAccountUser do
  @moduledoc """
    Account migration
  """

  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :integer
      add :currency, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)

      timestamps()
    end
  end
end
