defmodule Engine.CoinHandler.Collect do
  def run(account) do
    account
    |> Database.Account.get()
    |> check_admin_override()
    |> get_last_collect()
    |> check_last_collect()
    |> execute()
  end

  defp check_admin_override(account) do
    account
    |> Database.AccountSettings.all?([:admin, :admin_enabled])
    |> check_admin_override_verify(account)
  end

  defp check_admin_override_verify(true, account), do: {:override, account}
  defp check_admin_override_verify(false, account), do: {:ok, account}

  defp get_last_collect({:override, account}), do: {:override, account}
  defp get_last_collect({:ok, account}) do
    account
    |> Database.CoinTransaction.last("collect")
    |> get_last_collect_verify(account)
  end

  def get_last_collect_verify(nil, account), do: {:override, account}
  def get_last_collect_verify(transaction, account), do: {:ok, transaction, account}

  defp check_last_collect({:override, account}), do: {:ok, account}
  defp check_last_collect({:ok, transaction, account}) do
    transaction
    |> Database.CoinTransaction.fetch(:inserted_at)
    |> DateTime.to_date()
    |> Date.compare(Date.utc_today())
    |> check_last_collect_verify(account)
  end

  defp check_last_collect_verify(:lt, account), do: {:ok, account}
  defp check_last_collect_verify(_, _account), do: {:error, "Unable to collect another coin today.\nThe daily reset will happen in #{time_until_next_utc_day()}"}

  defp time_until_next_utc_day() do
    DateTime.utc_now()
    |> DateTime.to_date()
    |> Date.add(1)
    |> Date.to_iso8601(:extended)
    |> (_append_time = fn date -> date <> "T00:00:00Z" end).()
    |> DateTime.from_iso8601()
    |> (_extract_datetime = fn {:ok, datetime, _offset} -> datetime end).()
    |> DateTime.diff(DateTime.utc_now())
    |> (_extract_hours_from_seconds = fn seconds -> {Integer.floor_div(seconds, (60 * 60)), Integer.mod(seconds, 60 * 60)} end).()
    |> (_extract_minutes_from_seconds = fn {hours, seconds} -> {hours, Integer.floor_div(seconds, 60), Integer.mod(seconds, 60)} end).()
    |> time_until_next_utc_day_convert()
    |> String.trim()
  end

  defp time_until_next_utc_day_convert({0, minutes, seconds}), do: time_until_next_utc_day_convert({minutes, seconds})
  defp time_until_next_utc_day_convert({1, minutes, seconds}), do: "1 hour #{time_until_next_utc_day_convert({minutes, seconds})}"
  defp time_until_next_utc_day_convert({hours, minutes, seconds}), do: "#{hours} hours #{time_until_next_utc_day_convert({minutes, seconds})}"
  defp time_until_next_utc_day_convert({0, seconds}), do: time_until_next_utc_day_convert({seconds})
  defp time_until_next_utc_day_convert({1, seconds}), do: "1 minute #{time_until_next_utc_day_convert({seconds})}"
  defp time_until_next_utc_day_convert({minutes, seconds}), do: "#{minutes} minutes #{time_until_next_utc_day_convert({seconds})}"
  defp time_until_next_utc_day_convert({0}), do: ""
  defp time_until_next_utc_day_convert({1}), do: "1 second"
  defp time_until_next_utc_day_convert({seconds}), do: "#{seconds} seconds"

  defp execute({:error, _reason} = error), do: error
  defp execute({:ok, account}) do
    coin_transaction =
      Database.Coin.random()
      |> Database.CoinInstance.generate()
      |> Database.CoinTransaction.new(account, "collect")

    {:ok, coin_transaction}
  end
end
