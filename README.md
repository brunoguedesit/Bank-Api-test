# Bank Api test

[![Build Status](https://travis-ci.com/brunoguedesit/stone_bank.svg?token=ywpRyjxy3UtUGfJLcssT&branch=main)](https://travis-ci.com/brunoguedesit/stone_bank)
[![codecov](https://codecov.io/gh/brunoguedesit/stone_bank/branch/main/graph/badge.svg?token=L43T9NE2PC)](https://codecov.io/gh/brunoguedesit/stone_bank)

## Introduction

A Bank API that allows transactions between user accounts, deposit, transfer, withdraw, currency exchange and split payment operations.

## Live application

The application is running in the following URL:

https://stone-bank-api.gigalixirapp.com/

## CI/CD

 - **[Travis CI](https://travis-ci.com/)** for Continous Integration;
 - **[Gigalixir](https://gigalixir.com/)** for Continous Delivery.

## Technologies

- **[Docker](https://docs.docker.com)** and **[Docker Compose](https://docs.docker.com/compose/)** to create our development and test environments;
- **[Postgresql](https://www.postgresql.org/)** to store the data;
- **[Elixir](https://elixir-lang.org/)** language;
- **[Phoenix](https://www.phoenixframework.org/)** web framework.

 Some other important tools that were used:

- **[Credo](https://github.com/rrrene/credo)** for linting;
- **[Sobelow](https://github.com/nccgroup/sobelow)** for security analysis;
- **[Coveralls](https://github.com/parroty/excoveralls)** for test coverage;
- **[Codecov](https://about.codecov.io)** for a code coverage;
- **[ExMoney](https://github.com/kipcole9/money)** and  **[ExMoney_SQL](https://github.com/kipcole9/money_sql)** for money implementations according to **[ISO 4217](https://www.iso.org/iso-4217-currency-codes.html)**;
- **[PromEx](https://github.com/akoutmos/prom_ex)** to monitor our application exposing prometheus metrics.

## Prerequisites

- [docker](https://docs.docker.com/engine/install/ubuntu/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [elixir](https://elixir-lang.org/install.html)
- [phoenix](https://hexdocs.pm/phoenix/installation.html)

## Getting Started

Make sure that you have the prerequisites installed, then clone the repository:
```bash
$ git clone https://github.com/brunoguedesit/stone_bank
```

### Running Locally

```bash
# Get project dependencies & run the stack
$ mix deps.get
$ mix phx.server

# Run the tests
$ mix test

# Run the tests with coverage
$ mix coveralls
```

### Running Docker

Change the hostname value from both `config/dev.exs` and `config/test.exs` configuration files:

```elixir
config :stone_bank, StoneBank.Repo,
  hostname: "database",
```

Now, run with docker-compose:

```bash
# Run the stack
$ docker-compose up

# Run the tests
$ docker-compose exec stone_bank mix test

# Run the tests with coverage
$ docker-compose exec stone_bank mix coveralls
```
**WARNING:** if you want to switch to local run, delete your `_build` folder to compile without any errors.

## Available Routes

For more datails, you can check the [Postman API documentation](https://documenter.getpostman.com/view/3095470/TzJpj14c)

### Application Routes

| Routes                  | Description                                  | Methods HTTP |
|------------------------|--------------------------------------------|--------------|
|/api/auth/signup                | register a new user account    |  POST         |
|/api/auth/signin                 | login to get a JWT          | POST         |
|/api/balance/  | get user account balance                          | GET         |
|/api/operations/deposit  | make deposit   | PUT         |
|/api/operations/withdraw   | make withdrawals                      | PUT         |
|/api/operations/transfer  | make a transfer to another account   | PUT |
|/api/operations/exchange | make the currency exchange and withdraw | PUT |
|/api/operations/split_payment | make a split payment | PUT |

### Admin Access Routes

| Routes                  | Description                                  | Methods HTTP |
|------------------------|--------------------------------------------|--------------|
|/api/user                | get a user account by id   |  GET         |
|/api/users                 | get a list of all users accounts       | GET         |
|/api/transactions/all  | get all of transactions reports         | GET         |
|/api/transactions/year  | get transactions reports by year  | GET         |
|/api/transactions/month   | get transactions reports by month   | GET         |
|/api/transactions/day  | get transactions reports by day   | GET |

### Prometheus Routes

| Routes                  | Description                                  | Methods HTTP |
|------------------------|--------------------------------------------|--------------|
|/metrics                | get prometheus metrics   |  GET         |
