defmodule Scheduled.EvaluateCoinValues do
  def run() do
    Database.Coin.all()
    |> Enum.each(fn coin ->
      coin
      |> Database.Coin.update_value()
    end)

    Database.CoinInstance.all()
    |> Enum.each(fn coin_instance ->
      coin_instance
      |> Database.CoinInstance.update_value()
    end)
  end
end
