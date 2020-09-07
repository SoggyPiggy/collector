defmodule Commands.Command.Collection do
  @command %Commands.Command{
    id: :collection,
    title: "Collection",
    description: "View your collection of coins",
    aliases: ["c", "collection"],
    examples: [">c"]
  }

  def module(), do: @command

  def execute(_args, {account, message}) do
    (
      "<@#{account.discord_id}>\n"
    ) <> (
      account
      |> Database.CoinInstance.all()
      |> Enum.sort(fn a, b -> Database.Set.fetch(a, :id) < Database.Set.fetch(b, :id) end)
      |> Enum.map(fn coin -> "`#{Database.CoinInstance.reference(coin)}` #{Database.Set.structure(coin, :name) |> Enum.join(" > ")} > **#{Database.Coin.fetch(coin, :name)}** #{Database.CoinInstance.grade(coin)}" end)
      |> Enum.join("\n")
    )
    |> Discord.send(:reply, message)
  end
end
