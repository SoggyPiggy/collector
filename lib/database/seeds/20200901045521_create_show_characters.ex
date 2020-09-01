defmodule Database.Seeds.CreateShowCharacters20200901045521 do
  import Database

  def version(), do: 20200901045521

  def run() do
    set = create_set(%{name: "Shows", folder_dir: "shows"})

    characters = create_set(set, %{name: "Characters", folder_dir: "characters_01"})

    create_coin(characters, %{name: "Walt & Jesse", file_dir: "bb"})
    create_coin(characters, %{name: "Cooper", file_dir: "cooper"})
    create_coin(characters, %{name: "Brenden", file_dir: "dassey"})
    create_coin(characters, %{name: "James", file_dir: "end-of-the-world"})
    create_coin(characters, %{name: "Pablo Escobar", file_dir: "escobar"})
    create_coin(characters, %{name: "Joe", file_dir: "exotic"})
    create_coin(characters, %{name: "Dr. Fujika", file_dir: "fujika"})
    create_coin(characters, %{name: "Rick", file_dir: "rick"})
    create_coin(characters, %{name: "Steven", file_dir: "steven"})
    create_coin(characters, %{name: "Joyce", file_dir: "stranger-wall"})
    create_coin(characters, %{name: "Geralt", file_dir: "witcher"})
  end
end
