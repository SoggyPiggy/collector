defmodule Commands.Command.Collection do
  @command %Commands.Command{
    id: :collection,
    title: "Collection",
    description: "View your collection of coins",
    aliases: ["c", "collection"],
    examples: ["collection"],
    # args_strict: [{:page, :integer}],
    # args_aliases: [p: :page]
  }

  def module(), do: @command

  def execute(args, {account, _message} = reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_arguments(account)
    |> check_account(reply_data)
    |> check_coins()
    |> send_reply(reply_data)
  end

  defp check_arguments({_params, [_ | [_ | _]], _errors}, _account), do: {:error, "Too many users given"}
  defp check_arguments({_params, [], _errors}, account), do: {:ok, account}
  defp check_arguments({_params, [user], _errors}, _account), do: {:ok, user}

  defp check_account({:error, _reason} = error, _reply_data), do: error
  defp check_account({:ok, user}, reply_data) do
    user
    |> Collector.resolve_account(reply_data)
    |> check_account_verify()
  end

  defp check_account_verify({:ok, {:ok, item}}), do: {:ok, item}
  defp check_account_verify({:ok, %Database.Repo.Account{}} = data), do: data
  defp check_account_verify({:ok, _}), do: {:error, "User not found"}

  defp check_coins({:error, _reason} = error), do: error
  defp check_coins({:ok, account}) do
    account
    |> Database.CoinInstance.all()
    |> check_coins_verify(account)
  end

  defp check_coins_verify([], _account), do: {:error, "User has no coins"}
  defp check_coins_verify(coins, account), do: {:ok, account, coins}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, account, coins}, {_account, message}),
    do: Discord.send("#{username(account)}'s Collection", coins, :reply, message)

  defp username(account) do
    account
    |> Database.Account.fetch(:discord_id)
    |> Nostrum.Api.get_user!()
    |> Map.get(:username)
  end
end
