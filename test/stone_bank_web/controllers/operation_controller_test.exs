defmodule StoneBankWeb.OperationControllerTest do
  @moduledoc """
    Operation controller test module
  """
  use StoneBankWeb.ConnCase

  alias StoneBank.Accounts
  alias StoneBank.Accounts.User
  alias StoneBank.Repo
  import StoneBank.Accounts.Auth.Guardian

  @first_user %{
    email: "test@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test123",
    password_confirmation: "test123"
  }

  @second_user %{
    email: "test2@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test123",
    password_confirmation: "test123"
  }

  @third_user %{
    email: "test3@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test123",
    password_confirmation: "test123"
  }

  def create_first_user(:user) do
    {:ok, user, _} = Accounts.create_user(@first_user)
    user
  end

  def create_second_user(:user) do
    {:ok, user, _} = Accounts.create_user(@second_user)
    user
  end

  def create_third_user(:user) do
    {:ok, user, _} = Accounts.create_user(@third_user)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Account operations" do
    test "when given a valid value, returns an successfuly deposit", %{conn: conn} do
      user = create_first_user(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = put(conn, Routes.operation_path(conn, :deposit), value: 100)
      result = json_response(conn, 200)

      user = Repo.get(User, user.id) |> Repo.preload(:accounts)

      assert "Deposit with success!!! from: #{user.accounts.id} value: 100,00 BRL" ==
               Map.get(result, "message")
    end

    test "when given valid params, returns an successfuly withdraw", %{conn: conn} do
      user = create_first_user(:user)

      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = put(conn, Routes.operation_path(conn, :withdraw), value: 100)
      result = json_response(conn, 200)

      user = Repo.get(User, user.id) |> Repo.preload(:accounts)

      assert "Withdraw with success!!! from: #{user.accounts.id} value: 100,00 BRL" ==
               Map.get(result, "message")
    end

    test "When given more value than user amount for withdraw, returns an error", %{conn: conn} do
      user = create_first_user(:user)

      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = put(conn, Routes.operation_path(conn, :withdraw), value: 1100)
      result = json_response(conn, 422)

      assert "you can't have negative amount!" == Map.get(result, "message")
    end

    test "when given valid params, returns an successfuly transfer", %{conn: conn} do
      user1 = create_first_user(:user)
      user2 = create_second_user(:user)

      {:ok, token, _} = encode_and_sign(user1, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      user1 = Repo.get(User, user1.id) |> Repo.preload(:accounts)
      user2 = Repo.get(User, user2.id) |> Repo.preload(:accounts)

      assigns = %{to_account_id: user2.accounts.id, value: 1000}
      conn = put(conn, Routes.operation_path(conn, :transfer), assigns)
      result = json_response(conn, 200)

      expected_response =
        "Transfer with success!!! from: #{user1.accounts.id} to: #{user2.accounts.id} value: 1 000,00 BRL"

      assert expected_response == Map.get(result, "message")
    end

    test "when given more value than user amount for transfer, returns an error", %{conn: conn} do
      user1 = create_first_user(:user)
      user2 = create_second_user(:user)

      {:ok, token, _} = encode_and_sign(user1, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      Repo.get(User, user1.id) |> Repo.preload(:accounts)
      user2 = Repo.get(User, user2.id) |> Repo.preload(:accounts)

      assigns = %{to_account_id: user2.accounts.id, value: 1100}
      conn = put(conn, Routes.operation_path(conn, :transfer), assigns)
      result = json_response(conn, 422)

      assert "you can't have negative amount!" == Map.get(result, "message")
    end

    test "when given valid params, returns an successfuly exchange", %{conn: conn} do
      user = create_first_user(:user)

      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = put(conn, Routes.operation_path(conn, :exchange), value: 100, to_currency: :EUR)
      result = json_response(conn, 200)

      user = Repo.get(User, user.id) |> Repo.preload(:accounts)

      expected_response =
        "Exchange with success!!! from: #{user.accounts.id} value: 100,00 BRL converted to: 14,63 €"

      assert expected_response == Map.get(result, "message")
    end

    test "when given more value than user amount for exchange, returns an error", %{conn: conn} do
      user = create_first_user(:user)

      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      conn = put(conn, Routes.operation_path(conn, :exchange), value: 1100, to_currency: :EUR)
      result = json_response(conn, 422)

      assert "you can't have negative amount!" == Map.get(result, "message")
    end

    test "when given valid params, returns an successfuly split_payment", %{conn: conn} do
      user1 = create_first_user(:user)
      user2 = create_second_user(:user)
      user3 = create_third_user(:user)

      {:ok, token, _} = encode_and_sign(user1, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      user1 = Repo.get(User, user1.id) |> Repo.preload(:accounts)
      user2 = Repo.get(User, user2.id) |> Repo.preload(:accounts)
      user3 = Repo.get(User, user3.id) |> Repo.preload(:accounts)

      assigns = %{to_accounts_id: [user2.accounts.id, user3.accounts.id], value: 1000}
      conn = put(conn, Routes.operation_path(conn, :split_payment), assigns)
      result = json_response(conn, 200)

      expected_response =
        "Split payment with success!!! from: #{user1.accounts.id} value splited: 1 000,00 BRL for: #{
          user2.accounts.id
        }, #{user3.accounts.id}"

      assert expected_response == Map.get(result, "message")
    end

    test "when given more value than user amount for split payment, returns an error", %{
      conn: conn
    } do
      user1 = create_first_user(:user)
      user2 = create_second_user(:user)
      user3 = create_third_user(:user)

      {:ok, token, _} = encode_and_sign(user1, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)

      user2 = Repo.get(User, user2.id) |> Repo.preload(:accounts)
      user3 = Repo.get(User, user3.id) |> Repo.preload(:accounts)

      assigns = %{to_accounts_id: [user2.accounts.id, user3.accounts.id], value: 1100}
      conn = put(conn, Routes.operation_path(conn, :split_payment), assigns)
      result = json_response(conn, 422)

      assert "you can't have negative amount!" == Map.get(result, "message")
    end
  end
end
