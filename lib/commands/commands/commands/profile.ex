defmodule Commands.Command.Profile do
  @command %Commands.Command{
    id: :user,
    title: "Profile",
    description: "Shows a user's profile card",
    aliases: ["p", "profile", "stats"],
    examples: ["profile", "p <@468616309521776659>"]
  }

  def module(), do: @command

  def execute(args, {account, _message} = reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_arguments(account)
    |> check_account(reply_data)
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | _]], _errors}, _account), do: {:error, "Too many users given, but if you want to compare use pp compare command"}
  defp check_arguments({_params, [], _errors}, account), do: {:ok, account}
  defp check_arguments({_params, [user], _errors}, _account), do: {:ok, user}

  defp check_account({:error, _reason} = error, _reply_data), do: error
  defp check_account({:ok, user}, reply_data) do
    user
    |> Collector.resolve_account(reply_data)
  end

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
  do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, account}, {_account, message}),
  do: Discord.send("", account, :reply, message)
end
