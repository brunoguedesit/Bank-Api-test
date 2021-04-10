defmodule StoneBank.Accounts.Auth.Pipeline do
  @moduledoc """
    A guardian pipeline for a jwt authenticate
  """

  use Guardian.Plug.Pipeline,
    otp_app: :stone_bank,
    module: StoneBank.Accounts.Auth.Guardian,
    error_handler: StoneBank.Accounts.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
