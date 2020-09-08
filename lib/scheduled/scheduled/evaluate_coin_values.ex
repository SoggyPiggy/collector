defmodule Scheduled.EvaluateCoinValues do
  def run() do
    Database.Coin.all()
    |> update_coins()
    |> update_coin_instances()
  end

  defp update_coins(coins) do
    accounts_total =
      Database.Account.all()
      |> Enum.count()

    coins
    |> Enum.map(fn coin ->
      owners_count =
        coin
        |> Database.CoinInstance.all()
        |> Enum.map(fn instance -> instance.account_id end)
        |> Enum.filter(fn id -> id != nil end)
        |> Enum.uniq()
        |> Enum.count()

      coin
      |> Database.Coin.fetch(:weight)
      |> calculate_coin_weight_value()
      |> calculate_coin_unique_value(owners_count, accounts_total)
      |> calculate_coin_circulation_value(coin.in_circulation)
      # |> calculate_coin_error_value(coin.has_error)
      |> modify_coin_value(coin)
      |> Database.Coin.get()
    end)
  end

  defp calculate_coin_weight_value(weight), do: :math.pow((1000 / weight), 3) * 5

  defp calculate_coin_unique_value(value, 0, _accounts_total), do: value
  defp calculate_coin_unique_value(value, 1, _accounts_total), do: value
  defp calculate_coin_unique_value(value, owners_count, accounts_total), do: (
    value * 0.5 * (owners_count / accounts_total)
  ) + (
    value * 0.5
  )

  defp calculate_coin_circulation_value(value, true), do: value
  defp calculate_coin_circulation_value(value, false), do: value * 1.2

  # defp calculate_coin_error_value(value, true), value * 1.8
  # defp calculate_coin_error_value(value, false), value

  defp modify_coin_value(value, coin), do: Database.Coin.modify(coin, %{value: value})

  defp update_coin_instances(coins) do
    coins
    |> Enum.each(fn %{value: coin_value} = coin ->
      coin
      |> Database.CoinInstance.all()
      |> Enum.each(fn instance ->
        instance
        |> Database.CoinInstance.update_value(coin)
      end)
    end)
  end
end
