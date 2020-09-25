defmodule Discord.Speaker.AccountCompareEmbed do
  alias Nostrum.Struct.Embed

  defdelegate friendly_value(value), to: Database, as: :friendly_coin_value

  def build({account1, account2}) do
    {
      account1
      |> preload_account_info()
      |> build_data_map(),
      account2
      |> preload_account_info()
      |> build_data_map()
    }
    |> build_embed()
  end

  defp build_embed({data1, data2}) do
    %Embed{}
    |> Embed.put_title("Profile-to-Profile Comparison")
    |> Embed.put_field("#{data1.discord_user.username}'s Profile", """
    **Collection**: #{format_more(data1.coin_instances_count, data2.coin_instances_count)}
    **Collection Unique**: #{format_more(data1.coin_instances_unique_count, data2.coin_instances_unique_count)}
    **Collection Value**: #{format_more(data1.collection_value, data2.collection_value, &friendly_value/1)}
    **Collection Avg Value**: #{format_more(build_embed_average_worth(data1.collection_value, data1.coin_instances_count), build_embed_average_worth(data2.collection_value, data2.coin_instances_count))}
    **Collection MVC**: #{format_more(data1.most_value_coin, data2.most_value_coin, &friendly_value/1)}
    **Collection LVC**: #{format_less(data1.least_value_coin, data2.least_value_coin, &friendly_value/1)}

    **Coins Collected**: #{format_more(data1.coin_collected_count, data2.coin_collected_count)}
    **Coins Scrapped**: #{format_more(data1.coin_scrapped_count, data2.coin_scrapped_count)}

    **Scrap**: #{format_more(data1.scrap_current, data2.scrap_current)}
    **Scrap Collected**: #{format_more(data1.scrap_total, data2.scrap_total)}
    **Scrap Used**: #{format_more(data1.scrap_used, data2.scrap_used)}
    """, true)
    |> Embed.put_field("#{data2.discord_user.username}'s Profile", """
    **Collection**: #{format_more(data2.coin_instances_count, data1.coin_instances_count)}
    **Collection Unique**: #{format_more(data2.coin_instances_unique_count, data1.coin_instances_unique_count)}
    **Collection Value**: #{format_more(data2.collection_value, data1.collection_value, &friendly_value/1)}
    **Collection Avg Value**: #{format_more(build_embed_average_worth(data2.collection_value, data2.coin_instances_count), build_embed_average_worth(data1.collection_value, data1.coin_instances_count))}
    **Collection MVC**: #{format_more(data2.most_value_coin, data1.most_value_coin, &friendly_value/1)}
    **Collection LVC**: #{format_less(data2.least_value_coin, data1.least_value_coin, &friendly_value/1)}

    **Coins Collected**: #{format_more(data2.coin_collected_count, data1.coin_collected_count)}
    **Coins Scrapped**: #{format_more(data2.coin_scrapped_count, data1.coin_scrapped_count)}

    **Scrap**: #{format_more(data2.scrap_current, data1.scrap_current)}
    **Scrap Collected**: #{format_more(data2.scrap_total, data1.scrap_total)}
    **Scrap Used**: #{format_more(data2.scrap_used, data1.scrap_used)}
    """, true)
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
      |> Enum.filter(fn scrap -> scrap.reason == "repair" end)
      |> Enum.reduce(0, fn scrap, acc -> acc + scrap.amount end),
    scrap_total:
      account.scrap_transactions
      |> Enum.filter(fn scrap -> scrap.reason == "scrap" end)
      |> Enum.reduce(0, fn scrap, acc -> acc + scrap.amount end),
    most_value_coin:
      account.coin_instances
      |> IO.inspect()
      |> find_most_valuable(),
    least_value_coin:
      account.coin_instances
      |> find_least_valuable()
  }

  defp preload_account_info(account) do
    account
    |> Database.Account.get()
    |> Database.preload(:coin_instances)
    |> Database.preload(:coin_transactions)
    |> Database.preload(:scrap_transactions)
    |> Database.preload(:suggestions)
  end

  defp find_most_valuable([]), do: nil
  defp find_most_valuable([coin]), do: coin
  defp find_most_valuable([coin | tail]), do: find_most_valuable(coin, tail)
  defp find_most_valuable(coin, []), do: coin
  defp find_most_valuable(old, [new | tail]) do
    if new.value >= old.value do new else old end
    |> find_most_valuable(tail)
  end

  defp find_least_valuable([]), do: nil
  defp find_least_valuable([coin]), do: coin
  defp find_least_valuable([coin | tail]), do: find_least_valuable(coin, tail)
  defp find_least_valuable(coin, []), do: coin
  defp find_least_valuable(old, [new | tail]) do
    if new.value <= old.value do new else old end
    |> find_least_valuable(tail)
  end

  defp format_more(item1, item2, fun \\ (fn x -> x end))
  defp format_more(%Database.Repo.CoinInstance{} = coin1, %Database.Repo.CoinInstance{} = coin2, fun),
    do: format_more(coin1.value, coin2.value, fun)
  defp format_more(value1, value2, fun) when value1 > value2, do: "#{fun.(value1)} \🟢"
  defp format_more(value1, value2, fun) when value1 < value2, do: "#{fun.(value1)} \🔴"
  defp format_more(value1, _value2, fun), do: "#{fun.(value1)} \⚪"

  # defp format_less(item1, item2, fun \\ (fn x -> x end))
  defp format_less(%Database.Repo.CoinInstance{} = coin1, %Database.Repo.CoinInstance{} = coin2, fun),
    do: format_less(coin1.value, coin2.value, fun)
  defp format_less(value1, value2, fun) when value1 < value2, do: "#{fun.(value1)} \🟢"
  defp format_less(value1, value2, fun) when value1 > value2, do: "#{fun.(value1)} \🔴"
  defp format_less(value1, _value2, fun), do: "#{fun.(value1)} \⚪"
end
