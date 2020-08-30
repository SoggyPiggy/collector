defmodule Mix.Tasks.Collector.Seed.Gen do
  use Mix.Task

  @shortdoc "Generates a new data-seeding for the repo"

  def run([]), do: nil
  def run(args) do
    args
    |> Enum.join(" ")
    |> Database.seed_gen()
  end
end
