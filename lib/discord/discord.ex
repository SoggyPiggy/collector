defmodule Discord do
  alias Discord.Speaker

  defdelegate send(message, embed_item, destination, data), to: Speaker
  defdelegate send(message, destination, data), to: Speaker
  defdelegate send(message, channel_id), to: Speaker

  defdelegate get_dm_channel(discord_id), to: Nostrum.Api, as: :create_dm!
end
