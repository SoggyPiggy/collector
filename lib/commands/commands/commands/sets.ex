defmodule Commands.Command.Sets do
  require Ecto.Query

  @command %Commands.Command{
    id: :sets,
    title: "Sets",
    description: "List all the sets which have coins in them",
    aliases: ["sets"],
    examples: ["sets"]
  }

  def module(), do: @command

  def execute(_args, {_account, _message} = reply_data) do
    Database.Set.all()
    |> Enum.filter(&Database.Set.has_coin/1)
    |> check_sets()
    |> send_reply(reply_data)
  end

  defp check_sets([]), do: {:error, "No sets found"}
  defp check_sets(sets), do: {:ok, sets}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, sets}, {_account, message}),
    do: Discord.send("Sets", sets, :reply, message)
end
