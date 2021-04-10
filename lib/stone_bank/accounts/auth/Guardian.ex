defmodule StoneBank.Accounts.Auth.Guardian do
  @moduledoc """
    Module guardian to get a jwt authenticate
  """
  use Guardian, otp_app: :stone_bank

  alias StoneBank.Accounts
  alias StoneBank.Accounts.Auth.Session

  def authenticate(email, password) do
    case Session.authenticate(email, password) do
      {:ok, user} -> create_token(user)
      _ -> {:error, :unauthorized}
    end
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok, Accounts.get_user!(id)}
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
