defmodule Commands.Command.Help do
  @command %Commands.Command{
    id: :help,
    title: "Help",
    description: "Displays helpful information",
    aliases: ["help", "h"],
    examples: [">help"]
  }

  def module(), do: @command

  def execute(_args, {nil, message}),
    do: send_help(Commands.CommandOrganiser.commands(false), message)
  def execute(_args, {_account, message}),
    do: send_help(Commands.CommandOrganiser.commands(true), message)

  defp send_help(commands, message) do
    "__**Help Menu**__\n" <> (
      commands
      |> Enum.map(fn command -> command.module() end)
      |> Enum.map(fn command -> "**#{command.title}**: #{command.description}" end)
      |> Enum.join("\n")
    )
    |> DiscordReceiver.Speaker.send(:direct, message)
  end
end
