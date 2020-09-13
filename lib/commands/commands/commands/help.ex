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

  def execute(args, {account, _message} = reply_data) do
    commands = Commands.get_appropriate_commands(account)

    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_arguments(commands)
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | _]], _errors}, commands),
    do: {:ok, commands |> Enum.map(fn command -> command.module() end)}
  defp check_arguments({_params, [], _errors}, commands),
    do: {:ok, commands |> Enum.map(fn command -> command.module() end)}
  defp check_arguments({_params, [cmd], _errors}, commands) do
    commands
    |> Commands.find(cmd)
    |> check_arguments_verify()
  end

  defp check_arguments_verify(nil), do: {:error, "Command not found"}
  defp check_arguments_verify(command), do: {:ok, command.module()}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}), do: Discord.send("<@#{id}>, #{reason}", :direct, message)
  defp send_reply({:ok, %Commands.Command{} = command}, {_account, message}), do: Discord.send("", command, :direct, message)
  defp send_reply({:ok, commands}, {_account, message}), do: Discord.send("Help Menu", commands, :direct, message)
end
