defmodule StoneBankWeb.UserControllerTest do
  @moduledoc """
    User controller test module
  """

  use StoneBankWeb.ConnCase
  use ExUnit.Case, async: true
  alias StoneBank.Accounts
  import StoneBank.Accounts.Auth.Guardian

  @valid_params %{
    email: "test@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test123",
    password_confirmation: "test123"
  }

  @admin_params %{
    email: "admin@admin.com",
    first_name: "user",
    last_name: "admin",
    password: "admin123",
    password_confirmation: "admin123",
    role: "admin"
  }

  @invalid_params %{
    email: "test@test.com",
    first_name: "test",
    last_name: "user controller",
    password: "test12",
    password_confirmation: "test123"
  }

  def create_user(:user) do
    {:ok, user, _} = Accounts.create_user(@valid_params)
    user
  end

  def create_user_admin(:user) do
    {:ok, user, _} = Accounts.create_user(@admin_params)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "user manipulate" do
    test "when all params are valid, returns an user created", %{conn: conn} do
      user = @valid_params

      conn = post(conn, Routes.user_path(conn, :signup), user: user)
      result = json_response(conn, 201)

      assert %{"email" => "test@test.com", "first_name" => "test"} = Map.get(result, "user")
    end

    test "when there params are invalid, returns an error", %{conn: conn} do
      user = @invalid_params

      conn = post(conn, Routes.user_path(conn, :signup), user: user)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "when all params are valid, returns an successfully authentication", %{conn: conn} do
      user = create_user(:user)

      conn = post(conn, Routes.user_path(conn, :signin), email: user.email, password: "test123")
      result = json_response(conn, 201)

      assert "test@test.com" == Map.get(result, "data") |> Map.get("email")
      assert "test" == Map.get(result, "data") |> Map.get("first_name")
    end

    test "when given invalid email, returns an error", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :signin),
          email: "invalidformat.com",
          password: "test123"
        )

      result = json_response(conn, 422)

      assert "unauthorized" == Map.get(result, "message")
    end
  end

  describe "get user by id or all users" do
    test "when the user has role admin, returns a list with all users", %{conn: conn} do
      user = create_user_admin(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)
      conn = get(conn, Routes.user_path(conn, :index))

      result = Enum.count(json_response(conn, 200)["data"])
      assert result == 1
    end

    test "when the user has role admin, returns an user", %{conn: conn} do
      user = create_user_admin(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer " <> token)
      conn = get(conn, Routes.user_path(conn, :show), id: user.id)

      result = json_response(conn, 200)["data"]
      assert "admin@admin.com" == Map.get(result, "email")
      assert "admin" == Map.get(result, "role")
    end

    test "when the user dont have a jwt token, returns an error", %{conn: conn} do
      create_user(:user)

      conn_show = get(conn, Routes.user_path(conn, :show))
      show_result = json_response(conn_show, 401)

      conn_index = get(conn, Routes.user_path(conn, :index))
      index_result = json_response(conn_index, 401)

      assert "unauthenticated" == Map.get(show_result, "error")
      assert "unauthenticated" == Map.get(index_result, "error")
    end
  end
end
