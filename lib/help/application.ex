defmodule Help.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HelpWeb.Telemetry,
      # Start the Ecto repository
      Help.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Help.PubSub},
      # Start Finch
      {Finch, name: Help.Finch},
      # Start the Endpoint (http/https)
      HelpWeb.Endpoint
      # Start a worker by calling: Help.Worker.start_link(arg)
      # {Help.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Help.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
