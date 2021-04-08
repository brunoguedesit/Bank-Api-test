defmodule StoneBankWeb.FallbackController do
  use StoneBankWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(StoneBankWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
