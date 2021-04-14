defmodule StoneBank.AccountsTest do
  @moduledoc """
  Accounts test module
  """

  use StoneBank.DataCase

  alias StoneBank.Accounts
  alias StoneBank.Accounts.User
  alias StoneBank.Repo

  @valid_params %{
    email: "test@test.com",
    first_name: "test",
    last_name: "user",
    password: "test123",
    password_confirmation: "test123"
  }

  @invalid_params %{
    email: nil,
    first_name: nil,
    last_name: nil,
    password: nil,
    password_confirmation: nil
  }

  describe "user accounts" do
    test "where all params are valid, returns an user" do
      {:ok, %User{id: user_id}, _} = Accounts.create_user(@valid_params)
      user = Repo.get(User, user_id)

      assert "test" == Map.get(user, :first_name)
      assert "test@test.com" == Map.get(user, :email)
    end

    test "where there are invalid params, returns an error" do
      {:error, changeset} = Accounts.create_user(@invalid_params)

      expected_response = %{
        email: ["can't be blank"],
        first_name: ["can't be blank"],
        last_name: ["can't be blank"],
        password: ["can't be blank"],
        password_confirmation: ["can't be blank"]
      }

      assert expected_response == errors_on(changeset)
    end
  end
end
