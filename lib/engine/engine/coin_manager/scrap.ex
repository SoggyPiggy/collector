defmodule Engine.CoinHandler.Scrap do
  def run(account, coin_instance, params) do
    coin_instance
    |> check_coin_instance()
    |> check_coin_owner(account)
    |> execute(Keyword.get(params, :dry_run, false))
  end

  defp check_coin_instance(coin_instance) do
    coin_instance
    |> Database.CoinInstance.get()
    |> check_coin_instance_verify()
  end

  defp check_coin_instance_verify(nil), do: {:error, "Coin reference is invaild"}
  defp check_coin_instance_verify(coin), do: {:ok, coin}

  defp check_coin_owner({:error, _reason} = error, _account), do: error
  defp check_coin_owner({:ok, coin}, account) do
    coin
    |> Database.CoinInstance.owner?(account)
    |> check_coin_owner_verify({coin, account})
  end

  defp check_coin_owner_verify(false, _data), do: {:error, "You do not own that coin"}
  defp check_coin_owner_verify(true, {coin, account}), do: {:ok, coin, account}

  defp execute({:error, _reason} = error, _dry_run), do: error
  defp execute({:ok, coin, _account}, true = _dry_run), do: {:ok, coin_base_scrap_amount(coin), coin}
  defp execute({:ok, coin, account}, false = _dry_run) do
    amount =
      coin
      |> coin_base_scrap_amount()
      |> (_add_random = fn amount -> Enum.random(-30..30) + amount end).()
    coin_transaction = Database.CoinTransaction.new(coin, account, %{reason: "scrap", amount: -1}) |> Database.CoinTransaction.get()
    scrap_transaction = Database.ScrapTransaction.new(coin, account, %{reason: "scrap", amount: amount}) |> Database.ScrapTransaction.get()
    {:ok, amount, coin, coin_transaction, scrap_transaction}
  end

  defp coin_base_scrap_amount(coin) do
    coin
    |> Database.CoinInstance.fetch(:condition)
    |> (fn condition -> condition * 500 end).()
    |> ceil()
  end
end
