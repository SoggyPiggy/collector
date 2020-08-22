defmodule Commands.Command.Collect do
  @command %Commands.Command{
    id: :collect,
    title: "Collect",
    description: "Get your daily coin. Resets at 8pm EST",
    aliases: ["collect"],
    examples: [">collect"]
  }

  def module(), do: @command

  def execute(_args, {account, _message} = data) do
    account
    |> get_last_collect()
    |> compare_dates()
    |> collect(data)
  end

  defp collect(:lt, {account, message}) do
    Database.select_random_coin()
    |> Database.generate_coin_instance()
    |> Database.create_coin_transaction(account, %{reason: "collect"})
    |> send_reply(message)
  end
  defp collect(_, {%{discord_id: id}, message}) do
    """
    <@#{id}>, You're unable to collect again today.
    The daily reset will happen in #{get_time_until_next()}
    """
    |> Discord.send(:reply, message)
  end

  defp get_last_collect(account) do
    account
    |> Database.get_last_coin_transaction("collect")
  end

  defp compare_dates(nil), do: :lt
  defp compare_dates(%{inserted_at: collect_datetime}) do
      collect_datetime
      |> DateTime.to_date()
      |> Date.compare(Date.utc_today())
  end

  defp send_reply({:ok, %{account: account, } = coin_transaction}, message) do
    coin_art =
      coin_transaction
      |> Map.get(:coin_instance)
      |> Map.get(:coin)
      |> Database.get_coin_art_path(".png")
      |> File.read!()
    data =
      coin_transaction
      |> get_coin_structs()

    %{
      content: """
      <@#{account.discord_id}>
      **Name**: #{data.coin.name}
      **Grade**: #{data.coin_instance.condition |> get_condition_grade()}
      **Condition**: #{data.coin_instance.condition |> friendlify_condition()}
      """,
      file: %{name: "#{data.coin.id}.png", body: coin_art}
    }
    |> Discord.send(:reply, message)
  end

  defp get_condition_grade(condition) do
    condition
    |> case do
      x when x > 0.95 -> "About Uncirculated"
      x when x > 0.90 -> "Extremely Fine"
      x when x > 0.75 -> "Very Fine"
      x when x > 0.70 -> "Fine"
      x when x > 0.50 -> "Very Good"
      x when x > 0.25 -> "Good"
      x when x > 0.20 -> "About Good"
      x when x > 0.10 -> "Fair"
      _ -> "Poor"
    end
  end

  defp friendlify_condition(float) do
    (float * 100
    |> Float.to_string()
    |> String.slice(0..4))
    <> "%"
  end

  defp get_coin_structs(coin_transaction) do
    coin_instance = coin_transaction.coin_instance
    coin = coin_instance.coin
    category =
      coin
      |> Database.preload(:category)
      |> Map.get(:category)

    %{
      coin_transaction: coin_transaction,
      coin_instance: coin_instance,
      coin: coin,
      category: category
    }
  end

  defp get_time_until_next() do
    DateTime.utc_now()
    |> DateTime.to_date()
    |> Date.add(1)
    |> Date.to_iso8601(:extended)
    |> append_time()
    |> DateTime.from_iso8601()
    |> extract_datetime()
    |> DateTime.diff(DateTime.utc_now())
    |> extract_hours_from_seconds()
    |> extract_minutes_from_seconds()
    |> convert_remaining_time_to_string()
    |> String.trim()
  end

  defp append_time(date), do: date <> "T00:00:00Z"

  defp extract_datetime({:ok, datetime, _offset}), do: datetime

  defp extract_hours_from_seconds(seconds),
    do: {Integer.floor_div(seconds, (60 * 60)), Integer.mod(seconds, 60 * 60)}
  defp extract_minutes_from_seconds({hours, seconds}),
    do: {hours, Integer.floor_div(seconds, 60), Integer.mod(seconds, 60)}

  defp convert_remaining_time_to_string({0, minutes, seconds}), do: convert_remaining_time_to_string({minutes, seconds})
  defp convert_remaining_time_to_string({1, minutes, seconds}), do: "1 hour #{convert_remaining_time_to_string({minutes, seconds})}"
  defp convert_remaining_time_to_string({hours, minutes, seconds}), do: "#{hours} hours #{convert_remaining_time_to_string({minutes, seconds})}"
  defp convert_remaining_time_to_string({0, seconds}), do: convert_remaining_time_to_string({seconds})
  defp convert_remaining_time_to_string({1, seconds}), do: "1 minute #{convert_remaining_time_to_string({seconds})}"
  defp convert_remaining_time_to_string({minutes, seconds}), do: "#{minutes} minutes #{convert_remaining_time_to_string({seconds})}"
  defp convert_remaining_time_to_string({0}), do: ""
  defp convert_remaining_time_to_string({1}), do: "1 second"
  defp convert_remaining_time_to_string({seconds}), do: "#{seconds} seconds"
end
