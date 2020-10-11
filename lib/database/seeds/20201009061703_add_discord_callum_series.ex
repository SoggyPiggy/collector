defmodule Database.Seeds.AddDiscordCallumSeries20201009061703 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061703

  def run() do
    [name: "Discord", folder_dir: "discord"]
    |> Set.get()
    |> Set.new(%{name: "Callum's Brain Morsels", folder_dir: "callum"})
    |> Coin.new(%{name: "Spicy Madlads", file_dir: "spicy"})
  end
end
