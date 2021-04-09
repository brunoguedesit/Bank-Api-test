defmodule StoneBankWeb.FallbackController do
  use StoneBankWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(StoneBankWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(StoneBankWeb.ErrorView)
    |> render("error_message.json", message: message)
  end
end
