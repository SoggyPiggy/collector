defmodule Mix.Tasks.Collector.Command.Gen do
  use Mix.Task

  @shortdoc "Generates a new command for the bot"

  def run([]), do: nil
  def run(args) do
    args
    |> Enum.join(" ")
    |> Commands.generate_command()
  end
end
