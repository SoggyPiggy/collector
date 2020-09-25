defmodule Commands.Command.PpCompare do
  @command %Commands.Command{
    id: :pp_compare,
    title: "PP Compare",
    description: "Profile-to-Profile comparison",
    aliases: ["pp", "pp-compare"],
    examples: ["pp <@468616309521776659>"]
  }

  def module(), do: @command

  def execute(args, {account, _message} = reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_arguments(account)
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | [_ | _]]], _errors}, _account), do: {:error, "Too many users given"}
  defp check_arguments({_params, [], _errors}, _account), do: {:error, "Must provide at least one user"}
  defp check_arguments({_params, [account2], _errors}, account1) do
    {:ok, Database.Account.get(account1), Database.Account.get(account2)}
    |> check_arguments_verify()
  end
  defp check_arguments({_params, [account1 | [account2]], _errors}, _account) do
    {:ok, Database.Account.get(account1), Database.Account.get(account2)}
    |> check_arguments_verify()
  end

  defp check_arguments_verify({:ok, {:ok, item}, account}), do: check_arguments_verify({:ok, item, account})
  defp check_arguments_verify({:ok, account, {:ok, item}}), do: check_arguments_verify({:ok, account, item})
  defp check_arguments_verify({:ok, %Database.Repo.Account{}, %Database.Repo.Account{}} = data), do: data
  defp check_arguments_verify({:ok, _, _}), do: {:error, "Problem finding account"}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, account1, account2}, {_account, message}),
    do: Discord.send("", {account1, account2}, :reply, message)
end
