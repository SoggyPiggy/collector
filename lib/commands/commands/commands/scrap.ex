defmodule Commands.Command.Scrap do
  @command %Commands.Command{
    id: :scrap,
    title: "Scrap Coin",
    description: "Breaks down the coin into scrap metal",
    aliases: ["scr", "scrap"],
    examples: ["scrap 001A --dry-run", "scr 21 -d", "scr 1a"],
    args_strict: [{:dry_run, :boolean}],
    args_aliases: [d: :dry_run]
  }

  def module(), do: @command

  def execute(args, {account, _message} = reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_params()
    |> send_to_handler(account)
    |> send_reply(reply_data)
  end

  defp check_params({_params, [], _errors}), do: {:error, "Coin not provided"}
  defp check_params({_params, [_ | [_ | _]], _errors}), do: {:error, "Too many coin references provided"}
  defp check_params({params, [coin], _errors}), do: {:ok, coin, params}

  defp send_to_handler({:error, _reason} = error, _account), do: error
  defp send_to_handler({:ok, coin, params}, account), do: Engine.run_scrap(account, coin, params)

  def send_reply({:error, reason}, {%{discord_id: id}, message}), do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  def send_reply({:ok, amount, coin}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{Database.CoinInstance.reference(coin)} will yield roughly #{amount} scrap", :reply, message)
  def send_reply({:ok, _amount, _coin, _coin_transaction, scrap_transaction}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>", scrap_transaction, :reply, message)
end
