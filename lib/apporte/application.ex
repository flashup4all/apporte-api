defmodule Apporte.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ApporteWeb.Telemetry,
      # Start the Ecto repository
      Apporte.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Apporte.PubSub},
      # Start Finch
      {Finch, name: Apporte.Finch},
      # Start the Endpoint (http/https)
      ApporteWeb.Endpoint,
      # Start Oban Jobs
      {Oban, Application.fetch_env!(:apporte, Oban)}
      # Start a worker by calling: Apporte.Worker.start_link(arg)
      # {Apporte.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apporte.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ApporteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
