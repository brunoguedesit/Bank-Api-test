defmodule StoneBankWeb.TransactionControllerTest do
  @moduledoc """
    Transaction controller test module
  """

  use StoneBankWeb.ConnCase

  alias StoneBank.Accounts
  alias StoneBank.Transactions

  import StoneBank.Accounts.Auth.Guardian

  @valid_params %{
    email: "test@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test123",
    password_confirmation: "test123",
    role: "admin"
  }

  def create_transactions do
    [
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "deposit",
        date: ~D[2021-03-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "withdraw",
        date: ~D[2021-03-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "withdraw",
        date: ~D[2020-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "54321",
        type: "transfer",
        date: ~D[2021-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "nil",
        type: "exchange",
        date: ~D[2021-04-13]
      },
      %{
        value: Money.new(:BRL, "100"),
        account_from: "12345",
        account_to: "54321, 41234",
        type: "split_payment",
        date: ~D[2021-04-12]
      }
    ]
    |> Enum.map(fn transaction -> Transactions.create_transaction(transaction) end)
  end

  def create_user(:user) do
    create_transactions()
    {:ok, user, _} = Accounts.create_user(@valid_params)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Transactions" do
    test "when given valid transactions, returns an list of all transactions", %{conn: conn} do
      user = create_user(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = get(conn, Routes.transaction_path(conn, :all))
      result = json_response(conn, 200)["data"]
      total = Map.get(result, "total") |> Map.get("amount")
      total_transactions = Map.get(result, "transactions_list") |> Enum.count()

      assert "600" == total
      assert 6 == total_transactions
    end

    test "when given valid transactions, returns an list of transactions by year", %{conn: conn} do
      user = create_user(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = get(conn, Routes.transaction_path(conn, :year, "2021"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total") |> Map.get("amount")
      total_transactions = Map.get(result, "transactions_list") |> Enum.count()

      assert "500" == total
      assert 5 == total_transactions
    end

    test "when given valid transactions, returns an list of transactions by month", %{conn: conn} do
      user = create_user(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = get(conn, Routes.transaction_path(conn, :month, "2021", "04"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total") |> Map.get("amount")
      total_transactions = Map.get(result, "transactions_list") |> Enum.count()

      assert "300" == total
      assert 3 == total_transactions
    end

    test "when given valid transactions, returns an list of transactions by day", %{conn: conn} do
      user = create_user(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = get(conn, Routes.transaction_path(conn, :day, "2021-04-13"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total") |> Map.get("amount")
      total_transactions = Map.get(result, "transactions_list") |> Enum.count()

      assert "200" == total
      assert 2 == total_transactions
    end
  end
end
