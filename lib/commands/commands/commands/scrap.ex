defmodule Commands.Command.Scrap do
  @command %Commands.Command{
    id: :scrap,
    title: "Scrap Coin",
    description: "Breaks down the coin into scrap metal",
    aliases: ["scr", "scrap"],
    examples: [">scrap 001A", "scr 21 --estimate"],
    args_strict: [{:estimate, :boolean}],
    args_aliases: [e: :estimate]
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

  def scrap_coin({:error, _reason} = error), do: error
  def scrap_coin({:ok, coin, true}), do: {:ok, (
    coin
    |> Database.CoinInstance.reference()
  ) <> " will yield roughly " <> (
    coin
    |> Collector.scrap_coin_estimate()
    |> Integer.to_string()
  ) <> " scrap"}
  def scrap_coin({:ok, coin, false}) do
    {new_coin, scrap_transaction} = Collector.scrap_coin(coin)
    {:ok, (
      new_coin
      |> Database.CoinInstance.reference()
    ) <> " has been scrapped for " <> (
      scrap_transaction
      |> Database.ScrapTransaction.amount()
      |> Integer.to_string()
    ) <> " scrap"}
  end

  def send_reply({:error, reason}, {%{discord_id: id}, message}), do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  def send_reply({:ok, amount, coin}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{Database.CoinInstance.reference(coin)} will yield roughly #{amount} scrap", :reply, message)
  def send_reply({:ok, amount, coin, _coin_transaction, _scrap_transaction}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{Database.CoinInstance.reference(coin)} has been scrapped for #{amount} scrap", :reply, message)
end
