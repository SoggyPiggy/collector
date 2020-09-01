defmodule Database.Seeds.CreateBestiaryCryptids20200901045341 do
  import Database

  def version(), do: 20200901045341

	def run() do
    bestiary = create_set(%{name: "Bestiary", folder_dir: "bestiary"})

    cryptids = create_set(bestiary, %{name: "Cryptids", folder_dir: "cryptids_01"})

    create_coin(cryptids, %{name: "Altamaha-ha", file_dir: "altie"})
    create_coin(cryptids, %{name: "Bigfoot", file_dir: "bigfoot"})
    create_coin(cryptids, %{name: "Chupacabra", file_dir: "chupacabra"})
    create_coin(cryptids, %{name: "Dover Demon", file_dir: "dover-demon"})
    create_coin(cryptids, %{name: "Jersey Devil", file_dir: "jersey-devil"})
    create_coin(cryptids, %{name: "Mothman", file_dir: "mothman"})
    create_coin(cryptids, %{name: "Loch Ness Monster", file_dir: "nessy"})
    create_coin(cryptids, %{name: "Skunkape", file_dir: "skunk-ape"})
    create_coin(cryptids, %{name: "Dark Watchers", file_dir: "watchers"})
  end
end
