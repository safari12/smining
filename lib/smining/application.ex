defmodule Smining.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Smining.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: Smining.Worker.start_link(arg)
        # {Smining.Worker, arg},
        {Smining.Db, "./data"}
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Smining.Worker.start_link(arg)
      # {Smining.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Smining.Worker.start_link(arg)
      # {Smining.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:smining, :target)
  end
end
