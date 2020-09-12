defmodule Commands.Command.Collect do
  @command %Commands.Command{
    id: :collect,
    title: "Collect",
    description: "Get your daily coin. Resets at 8pm EST",
    aliases: ["collect"],
    examples: [">collect"]
  }

  def module(), do: @command

  def execute(_args, {account, _message} = reply_data) do
    account
    |> Engine.run_collect()
    |> send_reply(reply_data)
  end

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, coin_transaction}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>", Database.CoinInstance.get(coin_transaction), :reply, message)
end
