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
    |> check_accounts(reply_data)
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | [_ | _]]], _errors}, _account), do: {:error, "Too many users given"}
  defp check_arguments({_params, [], _errors}, _account), do: {:error, "Must provide at least one user"}
  defp check_arguments({_params, [account2], _errors}, account1), do: {:ok, account1, account2}
  defp check_arguments({_params, [account1 | [account2]], _errors}, _account), do: {:ok, account1, account2}

  defp check_accounts({:error, _reason} = error, _reply_data), do: error
  defp check_accounts({:ok, account1, account2}, reply_data) do
    {:ok, Collector.resolve_account(account1, reply_data), Collector.resolve_account(account2, reply_data)}
    |> check_accounts_verify()
  end

  defp check_accounts_verify({:ok, {:ok, item}, account}), do: check_accounts_verify({:ok, item, account})
  defp check_accounts_verify({:ok, account, {:ok, item}}), do: check_accounts_verify({:ok, account, item})
  defp check_accounts_verify({:ok, %Database.Repo.Account{}, %Database.Repo.Account{}} = ok), do: ok
  defp check_accounts_verify({:ok, _, _}), do: {:error, "Problem finding both accounts"}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, account1, account2}, {_account, message}),
    do: Discord.send("", {account1, account2}, :reply, message)
end
