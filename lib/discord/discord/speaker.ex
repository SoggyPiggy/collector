defmodule Discord.Speaker do
  alias Nostrum.Struct.Embed
  alias Database.{Coin, CoinInstance, Set}

  def send(message, {:ok, item}, type, data), do: send(message, item, type, data)
  def send(message, %Database.Repo.CoinInstance{} = coin, type, data) do
    [
      content: message,
      embed:
        %Embed{}
        |> Embed.put_title(Coin.fetch(coin, :name))
        |> Embed.put_author(Set.structure(coin, :name) |> Enum.join(" > "), nil, nil)
        |> Embed.put_description("**Grade**: #{CoinInstance.grade(coin)}")
        |> Embed.put_image(Collector.get_asset_url(coin, ".png"))
        |> Embed.put_footer(CoinInstance.reference(coin))
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
end
