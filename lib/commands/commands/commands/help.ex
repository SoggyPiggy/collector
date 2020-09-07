defmodule Commands.Command.Help do
  @command %Commands.Command{
    id: :help,
    title: "Help",
    description: "Displays helpful information",
    aliases: ["h", "help"],
    examples: [">help"],
    for_unregistered: true,
  }

  def module(), do: @command

  def execute(_args, {account, message}) do
    "__**Help Menu**__\n" <> (
      account
      |> Commands.get_appropriate_commands()
      |> Enum.map(fn command -> command.module() end)
      |> Enum.map(fn command -> "**#{command.title}**: `#{command.aliases |> List.first()}` #{command.description}" end)
      |> Enum.join("\n")
    )
    |> Discord.send(:direct, message)
  end
end
