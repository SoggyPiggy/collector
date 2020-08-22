defmodule Discord do
  alias Discord.Speaker

  defdelegate send(message, destination, data), to: Speaker
end
