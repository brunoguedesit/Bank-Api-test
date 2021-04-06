defmodule StoneBankWeb.PageController do
  use StoneBankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
