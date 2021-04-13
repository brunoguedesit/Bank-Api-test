defmodule StoneBank.Accounts.Account do
  @moduledoc """
    Account schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Jason.Encoder, only: [:amount]}

  schema "accounts" do
    field :amount, Money.Ecto.Composite.Type, default: Money.new(:BRL, 1000)
    belongs_to :user, StoneBank.Accounts.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:amount])
  end
end
