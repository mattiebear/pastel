defmodule Pastel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PastelWeb.Telemetry,
      Pastel.Repo,
      {DNSCluster, query: Application.get_env(:pastel, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pastel.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pastel.Finch},
      # Start a worker by calling: Pastel.Worker.start_link(arg)
      # {Pastel.Worker, arg},
      # Start to serve requests, typically the last entry
      PastelWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pastel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PastelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
