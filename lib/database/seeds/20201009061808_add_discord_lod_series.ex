defmodule Database.Seeds.AddDiscordLodSeries20201009061808 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061808

  def run() do
    [name: "Discord", folder_dir: "discord"]
    |> Set.get()
    |> Set.new(%{name: "Scrolls of Discordia", folder_dir: "lod_01"})
    |> Coin.new(%{name: "Abilities", file_dir: "ability", weight: 800})
    |> Coin.new(%{name: "Flail Build", file_dir: "flail", weight: 750})
    |> Coin.new(%{name: "Efficiency", file_dir: "recruitment"})
    |> Coin.new(%{name: "Decisions", file_dir: "resuscitate", weight: 900})
    |> Coin.new(%{name: "Bubbling", file_dir: "swamp-bubbles"})
    |> Coin.new(%{name: "Vagrants", file_dir: "yeoman-coins"})
  end
end
