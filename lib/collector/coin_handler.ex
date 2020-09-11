defmodule Collector.CoinHandler do
  def collect_coin(account) do
    Database.Coin.random()
    |> Database.CoinInstance.generate()
    |> Database.CoinTransaction.new(account, "collect")
  end

  def scrap_coin(coin) do
    coin
    |> Database.CoinInstance.get()
    |> Database.Account.get()
    |> scrap_coin_process(coin)
    |> scrap_coin_adjust_coin_instance()
  end

  defp scrap_coin_process(nil, _coin), do: {:error, "Coin has no owner"}
  defp scrap_coin_process(account, coin), do: {
    Database.CoinTransaction.new(coin, account, %{reason: "scrap", amount: -1}),
    Database.ScrapTransaction.new(account, coin,
      coin
      |> scrap_coin_estimate()
      |> (fn amount -> Enum.random(-5..5) + amount end).()
    )
  }

  defp scrap_coin_adjust_coin_instance({coin_instance, scrap_transaction}), do: {
    coin_instance
    |> Database.CoinInstance.modify(%{is_altered: true, condition:
      coin_instance
      |> Database.CoinInstance.fetch(:condition)
      |> (fn condition -> condition * 0.5 end).()
    }),
    scrap_transaction
  }

  def scrap_coin_estimate(coin) do
    coin
    |> Database.CoinInstance.fetch(:condition)
    |> scrap_coin_estimate_calculate_scrap()
  end

  defp scrap_coin_estimate_calculate_scrap(condition), do: (
    (condition * 50)
    |> round()
  )
end
