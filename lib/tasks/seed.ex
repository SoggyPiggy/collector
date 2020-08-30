defmodule Mix.Tasks.Collector.Seed do
  use Mix.Task

  @shortdoc "Runs the repository data-seeding"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:collector)
    Database.seed_data()
  end
end
