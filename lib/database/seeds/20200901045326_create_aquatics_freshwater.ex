defmodule Database.Seeds.CreateAquaticsFreshwater20200901045326 do
  import Database

  def version(), do: 20200901045326

	def run() do
    aquatics = create_set(%{name: "Aquatic Life", folder_dir: "aquatics"})

    freshwater = create_set(aquatics, %{name: "Freshwater Fish", folder_dir: "freshwater_01"})

    create_coin(freshwater, %{name: "Spotted Blue Eye", file_dir: "gertrudes-raindow"})
    create_coin(freshwater, %{name: "Rainbow Belly Pipefish", file_dir: "indian-royal-green-pipe"})
    create_coin(freshwater, %{name: "Burmese Dwarf Stickleback", file_dir: "paradoxus-toothepick"})
    create_coin(freshwater, %{name: "Peacock Gudgeon", file_dir: "peacock-gudgeon"})
    create_coin(freshwater, %{name: "Chequered Gudgeon", file_dir: "purple-morgurnda"})
    create_coin(freshwater, %{name: "Sawbwa Barb", file_dir: "rummy-nose-rasbora"})
    create_coin(freshwater, %{name: "Scarlet Badis", file_dir: "scarlet badis"})
  end
end
