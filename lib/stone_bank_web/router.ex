defmodule StoneBankWeb.Router do
  use StoneBankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug StoneBank.Accounts.Auth.Pipeline
  end

  scope "/api/auth", StoneBankWeb do
    post "/signup", UserController, :signup
    post "/signin", UserController, :signin
  end

  scope "/api", StoneBankWeb do
    pipe_through [:api, :auth]

    get "/user", UserController, :show
    get "/users", UserController, :index
    get "/balance", UserController, :balance

    put "/operations/transfer", OperationController, :transfer
    put "/operations/withdraw", OperationController, :withdraw
    put "/operations/exchange", OperationController, :exchange
    put "/operations/deposit", OperationController, :deposit
    put "operations/split_payment", OperationController, :split_payment

    get "/transactions/all", TransactionController, :all
    get "/transactions/year/:year", TransactionController, :year
    get "/transactions/year/:year/month/:month", TransactionController, :month
    get "/transactions/day/:day", TransactionController, :day
  end

  scope "/", StoneBankWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", StoneBankWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: StoneBankWeb.Telemetry
    end
  end
end
