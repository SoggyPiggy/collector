defmodule Database.Seeds.CreateGamesCharacters20200901045429 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045429

	def run() do
    set = Set.new(%{name: "Games", folder_dir: "games"})

    characters_1 = Set.new(set, %{name: "Characters", folder_dir: "characters_01"})

    Coin.new(characters_1, %{name: "Lahabrea", file_dir: "ascian"})
    Coin.new(characters_1, %{name: "Excalibur", file_dir: "excalibur"})
    Coin.new(characters_1, %{name: "Fragile", file_dir: "fragile"})
    Coin.new(characters_1, %{name: "Link", file_dir: "link"})
    Coin.new(characters_1, %{name: "Meat Boy", file_dir: "meat"})
    Coin.new(characters_1, %{name: "Tom Nook", file_dir: "nook"})
    Coin.new(characters_1, %{name: "PUBG Guy", file_dir: "pubg"})
    Coin.new(characters_1, %{name: "Ramirez", file_dir: "ramirez"})
    Coin.new(characters_1, %{name: "Steve", file_dir: "steve"})
    Coin.new(characters_1, %{name: "Tracer", file_dir: "tracer"})
    Coin.new(characters_1, %{name: "Trebuchet", file_dir: "trebuchet"})

    characters_2 = Set.new(set, %{name: "Characters: 2", folder_dir: "characters_02"})

    Coin.new(characters_2, %{name: "Agent 47", file_dir: "agent-47"})
    Coin.new(characters_2, %{name: "Baldi", file_dir: "baldi"})
    Coin.new(characters_2, %{name: "Counter-Terrorist", file_dir: "csgo-ct"})
    Coin.new(characters_2, %{name: "Terrorist", file_dir: "csgo-t"})
    Coin.new(characters_2, %{name: "The Knight", file_dir: "hallow"})
    Coin.new(characters_2, %{name: "Jeanette", file_dir: "jeanette"})
    Coin.new(characters_2, %{name: "Pac-man", file_dir: "pacman"})
    Coin.new(characters_2, %{name: "Evan MacMillan", file_dir: "trapper"})
  end
end
