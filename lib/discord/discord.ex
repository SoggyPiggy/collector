defmodule Discord do
  alias Discord.Speaker

  defdelegate send(message, destination, data), to: Speaker
  defdelegate send(message, channel_id), to: Speaker
end
