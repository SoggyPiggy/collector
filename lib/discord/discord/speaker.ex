defmodule Discord.Speaker do
  alias Nostrum.Struct.Embed
  alias Database.{Coin, CoinInstance, Set}

  def send(message, {:ok, item}, type, data), do: send(message, item, type, data)
  def send(title, embed_item, type, data) when is_list(embed_item) do
    [embed: embedify(embed_item) |> Embed.put_title(title)]
    |> Discord.send(type, data)
  end
  def send(message, embed_item, type, data) do
    [content: message, embed: embedify(embed_item)]
    |> Discord.send(type, data)
  end
  def send(message, type, data) when is_bitstring(message), do: send(%{content: message}, type, data)
  def send(message, :notify, data), do: send(message, :direct, data)
  def send(message, :reply, %Nostrum.Struct.Message{channel_id: channel_id}), do:
    send_message(message, channel_id)
  def send(message, :direct, %Nostrum.Struct.Message{author: %{id: id}}), do:
    send_message(message, Nostrum.Api.create_dm!(id).id)
  def send(message, :direct, %Nostrum.Struct.User{id: id}), do:
    send_message(message, Nostrum.Api.create_dm!(id).id)
  def send(message, id) when is_integer(id), do:
    send_message(message, id)

  defp send_message(message, id), do: Nostrum.Api.create_message(id, message)

  defp embedify(%Database.Repo.Account{} = account),
    do: Discord.Speaker.AccountEmbed.build(account)
  defp embedify(%Commands.Command{} = command),
    do: Discord.Speaker.CommandEmbed.build(command)
  defp embedify(%Changelog.MajorMinor{} = change_log),
    do: Discord.Speaker.ChangeLogEmbed.build(change_log)
  defp embedify({%Database.Repo.Account{}, %Database.Repo.Account{}} = accounts),
    do: Discord.Speaker.AccountCompareEmbed.build(accounts)
  defp embedify(%Database.Repo.CoinTransaction{} = coin_transaction),
    do: coin_transaction |> Database.CoinInstance.get() |> embedify()
  defp embedify(%Database.Repo.CoinInstance{} = coin) do
    %Embed{}
    |> Embed.put_title(Coin.fetch(coin, :name))
    |> Embed.put_author(Set.structure(coin, :name) |> Enum.join(" > "), nil, nil)
    |> Embed.put_description("""
    **Grade**: #{CoinInstance.grade(coin)}
    **Value**: #{Database.friendly_coin_value(coin)}
    """)
    |> Embed.put_image(Collector.get_asset_url(coin, ".png"))
    |> Embed.put_footer(CoinInstance.reference(coin))
  end
  defp embedify(%Database.Repo.Set{} = set) do
    %Embed{}
    |> Embed.put_title(Coin.fetch(set, :name))
    |> Embed.put_author(
      set
      |> Set.structure(:name)
      |> List.delete_at(-1)
      |> Enum.join(" > "), nil, nil)
    |> Embed.put_description("""
    """)
  end
  defp embedify(%Database.Repo.ScrapTransaction{reason: "repair"} = transaction) do
    %Embed{}
    |> Embed.put_title("#{Database.CoinInstance.reference(transaction)} Repaired")
    |> Embed.put_description("""
    #{Database.ScrapTransaction.fetch(transaction, :amount) |> abs()} scrap was used.
    Coin is now #{Database.CoinInstance.grade(transaction)} and is valued at #{Database.CoinInstance.value_raw(transaction) |> Database.friendly_coin_value()}
    """)
  end
  defp embedify(%Database.Repo.ScrapTransaction{reason: "scrap"} = transaction) do
    %Embed{}
    |> Embed.put_title("#{Database.CoinInstance.reference(transaction)} Scrapped")
    |> Embed.put_description("""
    #{Database.ScrapTransaction.fetch(transaction, :amount) |> abs()} scrap was gained.
    The coin has been discarded from your inventory.
    """)
  end
  defp embedify(list) when is_list(list) do
    content =
      list
      |> Enum.map(fn item -> embedify_list_item(item) end)
      |> Enum.join("\n")

    %Embed{}
    |> Embed.put_description(content)
  end

  defp embedify_list_item(%Changelog.MajorMinor{} = major_minor),
    do: "**`#{Changelog.get_version(major_minor)}` #{major_minor.name}**"
  defp embedify_list_item(%Database.Repo.CoinInstance{} = coin),
    do: "#{coin_ref(coin)} #{coin_grade(coin)} #{coin_set(coin)} > #{coin_name(coin)}"
  defp embedify_list_item(%Database.Repo.Set{} = set),
    do: Database.Set.structure(set, :name) |> Enum.join(" > ")
  defp embedify_list_item(%Commands.Command{} = command),
    do: "**#{command.title}**: `#{command.aliases |> List.first()}` #{command.description}"

  defp coin_ref(coin), do: "`#{Database.CoinInstance.reference(coin)}`"
  defp coin_set(coin), do: Database.Set.structure(coin, :name) |> Enum.join(" > ")
  defp coin_name(coin), do: "**#{Database.Coin.fetch(coin, :name)}**"
  defp coin_grade(coin), do: "`#{Database.CoinInstance.grade(coin) |> String.pad_trailing(10, " ")}`"
end
