defmodule Collector.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Database.Repo,
      # Start the endpoint when the application starts
      CollectorWeb.Endpoint,
      # Start the nostrum discord connection
      Discord.Consumer,
      # Start the LandOfDiscordia application
      LandOfDiscordia.TechDemo,
      # Update the coin values every hour
      %{id: "half-hourly-coin-value-update", start: {SchedEx, :run_every, [Scheduled, :run_evaluate_coin_values, [], "*/30 * * * *"]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Collector.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CollectorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
