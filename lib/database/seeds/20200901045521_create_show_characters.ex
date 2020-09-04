defmodule Database.Seeds.CreateShowCharacters20200901045521 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045521

  def run() do
    set = Set.new(%{name: "Shows", folder_dir: "shows"})

    characters = Set.new(set, %{name: "Characters", folder_dir: "characters_01"})

    Coin.new(characters, %{name: "Walt & Jesse", file_dir: "bb"})
    Coin.new(characters, %{name: "Cooper", file_dir: "cooper"})
    Coin.new(characters, %{name: "Brenden", file_dir: "dassey"})
    Coin.new(characters, %{name: "James", file_dir: "end-of-the-world"})
    Coin.new(characters, %{name: "Pablo Escobar", file_dir: "escobar"})
    Coin.new(characters, %{name: "Joe", file_dir: "exotic"})
    Coin.new(characters, %{name: "Dr. Fujika", file_dir: "fujika"})
    Coin.new(characters, %{name: "Rick", file_dir: "rick"})
    Coin.new(characters, %{name: "Steven", file_dir: "steven"})
    Coin.new(characters, %{name: "Joyce", file_dir: "stranger-wall"})
    Coin.new(characters, %{name: "Geralt", file_dir: "witcher"})
  end
end
