defmodule Commands.Command.Collect do
  alias Nostrum.Struct.Embed

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
    |> admin_override(Database.AccountSettings.all?(account, [:admin, :admin_enabled]))
    |> collect(data)
  end

  defp admin_override(_, true), do: :lt
  defp admin_override(result, _), do: result

  defp collect(:lt, {account, message}) do
    Database.Coin.random()
    |> Database.CoinInstance.generate()
    |> Database.CoinTransaction.new(account, "collect")
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
    |> Database.CoinTransaction.last("collect")
  end

  defp compare_dates(nil), do: :lt
  defp compare_dates(%{inserted_at: collect_datetime}) do
      collect_datetime
      |> DateTime.to_date()
      |> Date.compare(Date.utc_today())
  end

  defp send_reply({:ok, %{account: account, } = coin_transaction}, message) do
    data = get_coin_structs(coin_transaction)
    [
      content: "<@#{account.discord_id}> collected",
      # TODO: Add all the _coin.png's to the directories and add them to author url
      embed:
        %Embed{}
        |> Embed.put_title(data.coin.name)
        |> Embed.put_author(Database.Set.structure(data.coin, :name) |> Enum.join(" > "), nil, nil)
        |> Embed.put_description("**Grade**: #{Database.CoinInstance.grade(data.coin_instance)}")
        |> Embed.put_image(Collector.get_asset_url(data.coin))
    ]
    |> Discord.send(:reply, message)
  end

  defp get_coin_structs(coin_transaction) do
    coin_instance = coin_transaction.coin_instance
    coin = coin_instance.coin
    set =
      coin
      |> Database.preload(:set)
      |> Map.get(:set)

    %{
      coin_transaction: coin_transaction,
      coin_instance: coin_instance,
      coin: coin,
      set: set
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
