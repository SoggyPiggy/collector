defmodule Commands.Command.Repair do
  @command %Commands.Command{
    id: :repair,
    title: "Repair Coin",
    description: "Uses Scrap to repair a coin",
    aliases: ["rpr", "repair"],
    examples: [">rpr 001B -s 2500", "repair 22 --scrap 100 --dry-run"],
    args_strict: [scrap: :integer, dry_run: :boolean],
    args_aliases: [s: :scrap, d: :dry_run],
    args_descriptions: [
      scrap: "The amount of scrap used to repair the coin (REQUIRED)",
      dry_run: "If used the action will not be saved and will output relavant information"
    ]
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

  defp check_params({_params, [], _error}), do: {:error, "Coin not provided"}
  defp check_params({_params, [_ | [_ | _]], _error}), do: {:error, "Too many coin references provided"}
  defp check_params({params, [coin], _error}), do: {:ok, coin, params}

  defp send_to_handler({:error, _reason} = error, _account), do: error
  defp send_to_handler({:ok, coin, params}, account), do: Engine.run_repair(account, coin, params)

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, transaction}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>", transaction, :reply, message)
end
