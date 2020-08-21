defmodule Commands.Command.Help do
  @command %Commands.Command{
    id: :help,
    title: "Help",
    description: "Displays helpful information",
    aliases: ["help", "h"],
    examples: [">help"],
    for_unregistered: true,
  }

  def module(), do: @command

  def execute(_args, {account, message}) do
    "__**Help Menu**__\n" <> (
      Commands.commands(account != nil)
      |> Enum.map(fn command -> command.module() end)
      |> Enum.map(fn command -> "**#{command.title}**: #{command.description}" end)
      |> Enum.join("\n")
    )
    |> DiscordReceiver.Speaker.send(:direct, message)
  end
end
