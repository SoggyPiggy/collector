defmodule Database.Seeds.CreateAquaticsFreshwater20200901045326 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045326

	def run() do
    aquatics = Set.new(%{name: "Aquatic Life", folder_dir: "aquatics"})

    freshwater = Set.new(aquatics, %{name: "Freshwater Fish", folder_dir: "freshwater_01"})

    Coin.new(freshwater, %{name: "Spotted Blue Eye", file_dir: "gertrudes-raindow"})
    Coin.new(freshwater, %{name: "Rainbow Belly Pipefish", file_dir: "indian-royal-green-pipe"})
    Coin.new(freshwater, %{name: "Burmese Dwarf Stickleback", file_dir: "paradoxus-toothepick"})
    Coin.new(freshwater, %{name: "Peacock Gudgeon", file_dir: "peacock-gudgeon"})
    Coin.new(freshwater, %{name: "Chequered Gudgeon", file_dir: "purple-morgurnda"})
    Coin.new(freshwater, %{name: "Sawbwa Barb", file_dir: "rummy-nose-rasbora"})
    Coin.new(freshwater, %{name: "Scarlet Badis", file_dir: "scarlet badis"})
  end
end
