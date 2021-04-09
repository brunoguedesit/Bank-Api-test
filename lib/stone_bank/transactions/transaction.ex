defmodule StoneBank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
    transactions schema
  """

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_params [:value, :account_from, :account_to, :type, :date]

  schema "Transactions" do
    field :account_from, :string
    field :account_to, :string
    field :date, :date
    field :type, :string
    field :value, Money.Ecto.Composite.Type

    timestamps()
  end

  def changeset(transaction, params) do
    transaction
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
