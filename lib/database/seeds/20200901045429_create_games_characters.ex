defmodule Database.Seeds.CreateGamesCharacters20200901045429 do
  import Database

  def version(), do: 20200901045429

	def run() do
    set = create_set(%{name: "Games", folder_dir: "games"})

    characters_1 = create_set(set, %{name: "Characters", folder_dir: "characters_01"})

    create_coin(characters_1, %{name: "Lahabrea", file_dir: "ascian"})
    create_coin(characters_1, %{name: "Excalibur", file_dir: "excalibur"})
    create_coin(characters_1, %{name: "Fragile", file_dir: "fragile"})
    create_coin(characters_1, %{name: "Link", file_dir: "link"})
    create_coin(characters_1, %{name: "Meat Boy", file_dir: "meat"})
    create_coin(characters_1, %{name: "Tom Nook", file_dir: "nook"})
    create_coin(characters_1, %{name: "PUBG Guy", file_dir: "pubg"})
    create_coin(characters_1, %{name: "Ramirez", file_dir: "ramirez"})
    create_coin(characters_1, %{name: "Steve", file_dir: "steve"})
    create_coin(characters_1, %{name: "Tracer", file_dir: "tracer"})
    create_coin(characters_1, %{name: "Trebuchet", file_dir: "trebuchet"})

    characters_2 = create_set(set, %{name: "Characters: 2", folder_dir: "characters_02"})

    create_coin(characters_2, %{name: "Agent 47", file_dir: "agent-47"})
    create_coin(characters_2, %{name: "Baldi", file_dir: "baldi"})
    create_coin(characters_2, %{name: "Counter-Terrorist", file_dir: "csgo-ct"})
    create_coin(characters_2, %{name: "Terrorist", file_dir: "csgo-t"})
    create_coin(characters_2, %{name: "The Knight", file_dir: "hallow"})
    create_coin(characters_2, %{name: "Jeanette", file_dir: "jeanette"})
    create_coin(characters_2, %{name: "Pac-man", file_dir: "pacman"})
    create_coin(characters_2, %{name: "Evan MacMillan", file_dir: "trapper"})
  end
end
