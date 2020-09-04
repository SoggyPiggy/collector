defmodule Database.Seeds.CreateBestiaryCryptids20200901045341 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045341

	def run() do
    bestiary = Set.new(%{name: "Bestiary", folder_dir: "bestiary"})

    cryptids = Set.new(bestiary, %{name: "Cryptids", folder_dir: "cryptids_01"})

    Coin.new(cryptids, %{name: "Altamaha-ha", file_dir: "altie"})
    Coin.new(cryptids, %{name: "Bigfoot", file_dir: "bigfoot"})
    Coin.new(cryptids, %{name: "Chupacabra", file_dir: "chupacabra"})
    Coin.new(cryptids, %{name: "Dover Demon", file_dir: "dover-demon"})
    Coin.new(cryptids, %{name: "Jersey Devil", file_dir: "jersey-devil"})
    Coin.new(cryptids, %{name: "Mothman", file_dir: "mothman"})
    Coin.new(cryptids, %{name: "Loch Ness Monster", file_dir: "nessy"})
    Coin.new(cryptids, %{name: "Skunkape", file_dir: "skunk-ape"})
    Coin.new(cryptids, %{name: "Dark Watchers", file_dir: "watchers"})
  end
end
