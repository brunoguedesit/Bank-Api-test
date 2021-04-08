defmodule StoneBank.Accounts.Account do
  @moduledoc """
    Account schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "accounts" do
    field :amount, Money.Ecto.Amount.Type, default: 1000
    field :currency, Money.Currency.Ecto.Type, default: :BRL
    belongs_to :user, StoneBank.Accounts.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:amount])
    |> validate_required(:amount)
  end
end