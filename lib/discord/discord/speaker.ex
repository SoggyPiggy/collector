defmodule Discord.Speaker do
  alias Nostrum.Struct.Embed
  alias Database.{Coin, CoinInstance, Set}

  def send(message, {:ok, item}, type, data), do: send(message, item, type, data)
  def send(message, embed_item, type, data) do
    [
      content: message,
      embed: embedify(embed_item)
    ]
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

  defp embedify(%Database.Repo.Account{} = account) do
    Discord.Speaker.AccountEmbed.build(account)
  end
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
  defp embedify(%Changelog.MajorMinor{} = change_log) do
    Discord.Speaker.ChangeLogEmbed.build(change_log)
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
end
