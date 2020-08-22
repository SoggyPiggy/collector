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
      account
      |> get_list()
      |> Enum.map(fn command -> command.module() end)
      |> Enum.map(fn command -> "**#{command.title}**: #{command.description}" end)
      |> Enum.join("\n")
    )
    |> DiscordReceiver.Speaker.send(:direct, message)
  end

  defp get_list(nil), do: Commands.commands_unregistered()
  defp get_list(account), do: Database.has_admin_override(account) |> get_list(account)
  defp get_list(true, _), do: Commands.commands_admin()
  defp get_list(false, _), do: Commands.commands_registered()
end
