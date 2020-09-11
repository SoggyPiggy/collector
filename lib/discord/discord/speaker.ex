defmodule Discord.Speaker do
  alias Nostrum.Struct.Embed
  alias Database.{Coin, CoinInstance, Set}

  def send(message, {:ok, item}, type, data), do: send(message, item, type, data)
  def send(message, embed_item, type, data) do
    [
      content: message,
      embed: embedify(embed_item)
    ]
    |> Discord.send(type, data)
  end
  def send(message, type, data) when is_bitstring(message), do: send(%{content: message}, type, data)
  def send(message, :notify, data), do: send(message, :direct, data)
  def send(message, :reply, %Nostrum.Struct.Message{channel_id: channel_id}), do:
    send_message(message, channel_id)
  def send(message, :direct, %Nostrum.Struct.Message{author: %{id: id}}), do:
    send_message(message, Nostrum.Api.create_dm!(id).id)
  def send(message, :direct, %Nostrum.Struct.User{id: id}), do:
    send_message(message, Nostrum.Api.create_dm!(id).id)
  def send(message, id) when is_integer(id), do:
    send_message(message, id)

  defp send_message(message, id), do: Nostrum.Api.create_message(id, message)

  defp embedify(%Database.Repo.Account{} = account) do
    account =
      account
      |> Database.Account.get()
      |> Database.preload(:coin_instances)
      |> Database.preload(:coin_transactions)
      |> Database.preload(:suggestions)
    discord_user = Nostrum.Api.get_user!(account.discord_id)
    coins = Database.Account.fetch(account, :coin_instances)
    coin_count = coins |> Enum.count()
    collected_coins_count =
      account
      |> Database.Account.fetch(:coin_transactions)
      |> Enum.filter(fn transaction -> transaction.reason == "collect" end)
      |> Enum.reduce(0, fn transaction, acc -> acc + transaction.amount end)
      |> Enum.count()
    worth_total = Enum.reduce(coins, 0, fn coin, acc -> acc + coin.value end)
    worth_average = worth_total / coin_count

    %Embed{}
    |> Embed.put_title("#{discord_user.username}'s Profile")
    |> Embed.put_description("""
    **Collection Count**: #{coin_count}
    **Collection Value**: #{Database.friendly_coin_value(worth_total)}
    **Collection Average**: #{Database.friendly_coin_value(worth_average)}

    **Coins Collected**: #{collected_coins_count}
    """)
    |> Embed.put_thumbnail(Nostrum.Struct.User.avatar_url(discord_user))
  end
  defp embedify(%Database.Repo.CoinInstance{} = coin) do
    %Embed{}
    |> Embed.put_title(Coin.fetch(coin, :name))
    |> Embed.put_author(Set.structure(coin, :name) |> Enum.join(" > "), nil, nil)
    |> Embed.put_description("""
    **Grade**: #{CoinInstance.grade(coin)}
    **Value**: #{Database.friendly_coin_value(coin)}
    """)
    |> Embed.put_image(Collector.get_asset_url(coin, ".png"))
    |> Embed.put_footer(CoinInstance.reference(coin))
  end
end
