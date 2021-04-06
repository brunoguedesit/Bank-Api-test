defmodule StoneBank.Accounts.Account do
  @moduledoc """
    Account schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "accounts" do
    field :amount, Money.Ecto.Amount.Type, default_currency: :BRL, default: 1000
    belongs_to :user, StoneBank.Accounts.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:amount])
    |> validate_required(:amount)
  end
end
