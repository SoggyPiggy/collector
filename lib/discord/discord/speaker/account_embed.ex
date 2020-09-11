defmodule Discord.Speaker.AccountEmbed do
  alias Nostrum.Struct.Embed

  defdelegate friendly_value(value), to: Database, as: :friendly_coin_value

  def build(account) do
    account
    |> preload_account_info()
    |> build_data_map()
    |> build_embed()
  end

  defp build_embed(data) do
    %Embed{}
    |> Embed.put_title("#{data.discord_user.username}'s Profile")
    |> Embed.put_thumbnail(Nostrum.Struct.User.avatar_url(data.discord_user))
    |> Embed.put_description("""
    **Collection**: #{data.coin_instances_count}
    **Collection Unique**: #{data.coin_instances_unique_count}
    **Collection Value**: #{data.collection_value |> friendly_value()}
    **Collection Avg Value**: #{build_embed_average_worth(data.collection_value, data.coin_instances_count)}

    **Coins Collected**: #{data.coin_collected_count}
    **Coins Scrapped**: #{data.coin_scrapped_count}

    **Scrap**: #{data.scrap_current}
    **Scrap Collected**: #{data.scrap_total}
    **Scrap Used**: #{data.scrap_used}
    """)
  end

  defp build_embed_average_worth(_, 0), do: 0.0 |> friendly_value()
  defp build_embed_average_worth(total, count), do: (total / count) |> friendly_value()

  defp build_data_map(account), do: %{
    account: account,
    discord_user: Nostrum.Api.get_user!(account.discord_id),
    coin_instances: account.coin_instances,
    coin_transactions: account.coin_transactions,
    scrap_transactions: account.scrap_transactions,
    coin_instances_count: Enum.count(account.coin_instances),
    coin_instances_unique_count:
      account.coin_instances
      |> Enum.map(fn coin_instance -> coin_instance.coin_id end)
      |> Enum.uniq()
      |> Enum.count(),
    coin_collected_count:
      account.coin_transactions
      |> Enum.filter(fn transaction -> transaction.reason == "collect" end)
      |> Enum.count(),
    coin_scrapped_count:
      account.coin_transactions
      |> Enum.filter(fn transaction -> transaction.reason == "scrap" end)
      |> Enum.count(),
    collection_value: Enum.reduce(account.coin_instances, 0.0, fn coin, acc -> acc + coin.value end),
    scrap_current: Enum.reduce(account.scrap_transactions, 0, fn scrap, acc -> acc + scrap.amount end),
    scrap_used:
      account.scrap_transactions
      |> Enum.filter(fn scrap -> scrap.amount < 0 end)
      |> Enum.reduce(0, fn scrap, acc -> acc + scrap.amount end),
    scrap_total:
      account.scrap_transactions
      |> Enum.filter(fn scrap -> scrap.amount > 0 end)
      |> Enum.reduce(0, fn scrap, acc -> acc + scrap.amount end)
  }

  def preload_account_info(account) do
    account
    |> Database.Account.get()
    |> Database.preload(:coin_instances)
    |> Database.preload(:coin_transactions)
    |> Database.preload(:scrap_transactions)
    |> Database.preload(:suggestions)
  end
end
