defmodule Engine.CoinHandler.Repair do
  @repair_ceiling 0.95

  def run(account, coin_instance, params) do
    coin_instance
    |> check_coin_instance()
    |> check_coin_condition()
    |> check_coin_owner(account)
    |> check_params_scrap(params)
    |> check_account_scrap()
    |> repair_calculate()
    |> update_database(Keyword.get(params, :dry_run, false))
  end

  defp check_coin_instance(coin_instance) do
    coin_instance
    |> Database.CoinInstance.get()
    |> check_coin_instance_verify()
  end

  defp check_coin_instance_verify(nil), do: {:error, "Coin reference is invaild"}
  defp check_coin_instance_verify(coin), do: {:ok, coin}

  defp check_coin_condition({:error, _reason} = error), do: error
  defp check_coin_condition({:ok, coin}) do
    coin
    |> Database.CoinInstance.fetch(:condition)
    |> check_coin_condition_verify(coin)
  end

  defp check_coin_condition_verify(condition, _coin) when condition >= @repair_ceiling,
    do: {:error, "Coin can no longer be repaired"}
  defp check_coin_condition_verify(_condition, coin),
    do: {:ok, coin}

  defp check_coin_owner({:error, _reason} = error, _account), do: error
  defp check_coin_owner({:ok, coin}, account) do
    coin
    |> Database.CoinInstance.owner?(account)
    |> check_coin_owner_verify({coin, account})
  end

  defp check_coin_owner_verify(false, _data), do: {:error, "You do not own that coin"}
  defp check_coin_owner_verify(true, {coin, account}), do: {:ok, coin, account}

  defp check_params_scrap({:error, _reason} = error, _params), do: error
  defp check_params_scrap({:ok, coin, account}, params) do
    params
    |> IO.inspect()
    |> Keyword.get(:scrap, 0)
    |> IO.inspect()
    |> check_params_scrap_verify(coin, account)
    |> IO.inspect()
  end

  defp check_params_scrap_verify(scrap, _coin, _account) when scrap <= 0, do: {:error, "You need to specify to use some scrap"}
  defp check_params_scrap_verify(scrap, coin, account), do: {:ok, coin, account, scrap}

  defp check_account_scrap({:error, _reason} = error), do: error
  defp check_account_scrap({:ok, coin, account, scrap}) do
    account
    |> Database.ScrapTransaction.sum()
    |> check_account_scrap_verify(coin, account, scrap)
  end

  defp check_account_scrap_verify(scrap_sum, _coin, _account, scrap) when scrap_sum < scrap,
    do: {:error, "You do not have #{scrap} scrap to use. You have #{scrap_sum}"}
  defp check_account_scrap_verify(_scrap_sum, coin, account, scrap), do: {:ok, coin, account, scrap}

  def repair_calculate({:error, _reason} = error), do: error
  def repair_calculate({:ok, coin, account, scrap}) do
    coin
    |> Database.CoinInstance.fetch(:condition)
    |> repair_calculate_prep(scrap)
    |> repair_calculate_step()
    |> repair_calculate_finalize(coin, account, scrap)
  end

  defp repair_calculate_prep(condition, scrap),
    do: {floor(condition * 100), scrap, (condition * 100) - floor(condition * 100)}

  defp repair_calculate_step({condition, scrap, _remaining}) when condition >= @repair_ceiling * 100,
    do: {condition, scrap, 0}
  defp repair_calculate_step({condition, 0, remaining}),
    do: {condition, 0, remaining}
  defp repair_calculate_step({condition, scrap, remaining}) when scrap >= condition,
    do: {condition + 1, scrap - condition, remaining} |> repair_calculate_step()
  defp repair_calculate_step({condition, scrap, remaining}),
    do: {condition, 0, remaining + (scrap / condition)} |> repair_calculate_step()

  defp repair_calculate_finalize({condition, unused_scrap, remaining}, coin, account, scrap), do: {
    :ok,
    coin,
    account,
    (scrap - unused_scrap) * -1,
    (condition + remaining) / 100
  }

  defp update_database({:error, _reason} = error, _dry_run), do: error
  defp update_database({:ok, coin, _account, scrap_used, new_condition}, true), do: {
    :ok,
    %Database.Repo.ScrapTransaction{
      coin_instance:
        coin
        |> Map.put(:condition, new_condition),
      reason: "repair",
      amount: scrap_used
    }
  }
  defp update_database({:ok, coin, account, scrap_used, new_condition}, false) do
    coin =
      coin
      |> Database.CoinInstance.modify(%{is_altered: true, condition: new_condition})
      |> Database.CoinInstance.update_value()

    transaction = Database.ScrapTransaction.new(coin, account, %{reason: "repair", amount: scrap_used})
    {:ok, transaction}
  end
end
