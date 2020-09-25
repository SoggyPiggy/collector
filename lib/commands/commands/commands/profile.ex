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
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | _]], _errors}, _account), do: {:error, "Too many users given, but if you want to compare use pp compare command"}
  defp check_arguments({_params, [], _errors}, account) do
    {:ok, account}
    |> check_arguments_verify()
  end
  defp check_arguments({_params, [user], _errors}, _account) do
    {:ok, Database.Account.get(user)}
    |> check_arguments_verify()
  end

  defp check_arguments_verify({:ok, {:ok, item}}), do: {:ok, item}
  defp check_arguments_verify({:ok, %Database.Repo.Account{}} = data), do: data
  defp check_arguments_verify({:ok, _}), do: {:error, "User not found"}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
  do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, account}, {_account, message}),
  do: Discord.send("", account, :reply, message)
end
