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
    |> argument_process()
    |> check_coin(account)
    |> scrap_coin()
    |> send_reply(reply_data)
  end

  def argument_process({_args, [], _errors}), do: {:error, "Coin not provided"}
  def argument_process({_args, [_ | [_ | _]], _errors}), do: {:error, "Too many base arguments provided"}
  def argument_process({args, [coin], _errors}), do: argument_process(
    coin
    |> Database.CoinInstance.get(),
    args
    |> Keyword.get(:estimate, false)
  )
  def argument_process(nil, _), do: {:error, "Coin reference is not vaild"}
  def argument_process(coin, only_estimate), do: {:ok, coin, only_estimate}

  def check_coin({:error, _reason} = error, _account), do: error
  def check_coin({:ok, coin, _only_estimate} = data, account) do
    coin
    |> Database.CoinInstance.owner?(account)
    |> check_coin(data)
  end
  def check_coin(true, data), do: data
  def check_coin(false, _data), do: {:error, "You can not scrap a coin that is not yours"}

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
  def send_reply({:ok, response}, {%{discord_id: id}, message}), do: Discord.send("<@#{id}>, " <> response, :reply, message)
end
