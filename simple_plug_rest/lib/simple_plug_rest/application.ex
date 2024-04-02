defmodule SimplePlugRest.Application do
  @moduledoc """
  The main application, responsible for starting the server and database
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start `SimplePlugRest` and listen on port 3000
      {Plug.Cowboy, scheme: :http, plug: SimplePlugRest, options: [port: 3000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimplePlugRest.Supervisor]

    IO.puts("Starting server")
    res = Supervisor.start_link(children, opts)

    IO.puts("Starting database")
    spawn(Database, :init, [])
    res
  end
end
