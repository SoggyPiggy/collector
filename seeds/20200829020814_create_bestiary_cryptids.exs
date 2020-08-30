import Database

creatures =
  create_set(%{name: "Bestiary", folder_dir: "bestiary"})

classics =
  creatures
  |> create_set(%{name: "Cryptids", folder_dir: "cryptids_01"})

classics |> create_coin(%{name: "Altamaha-ha", file_dir: "altie"})
classics |> create_coin(%{name: "Bigfoot", file_dir: "bigfoot"})
classics |> create_coin(%{name: "Chupacabra", file_dir: "chupacabra"})
classics |> create_coin(%{name: "Dover Demon", file_dir: "dover-demon"})
classics |> create_coin(%{name: "Jersey Devil", file_dir: "jersey-devil"})
classics |> create_coin(%{name: "Mothman", file_dir: "mothman"})
classics |> create_coin(%{name: "Loch Ness Monster", file_dir: "nessy"})
classics |> create_coin(%{name: "Skunkape", file_dir: "skunk-ape"})
classics |> create_coin(%{name: "Dark Watchers", file_dir: "watchers"})
