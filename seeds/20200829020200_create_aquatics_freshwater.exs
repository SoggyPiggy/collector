import Database

aquatics =
  create_set(%{name: "Aquatic Life", folder_dir: "aquatics"})

freshwater =
  aquatics
  |> create_set(%{name: "Freshwater Fish", folder_dir: "freshwater_01"})

freshwater |> create_coin(%{name: "Spotted Blue Eye", file_dir: "gertrudes-raindow"})
freshwater |> create_coin(%{name: "Rainbow Belly Pipefish", file_dir: "indian-royal-green-pipe"})
freshwater |> create_coin(%{name: "Burmese Dwarf Stickleback", file_dir: "paradoxus-toothepick"})
freshwater |> create_coin(%{name: "Peacock Gudgeon", file_dir: "peacock-gudgeon"})
freshwater |> create_coin(%{name: "Chequered Gudgeon", file_dir: "purple-morgurnda"})
freshwater |> create_coin(%{name: "Sawbwa Barb", file_dir: "rummy-nose-rasbora"})
freshwater |> create_coin(%{name: "Scarlet Badis", file_dir: "scarlet badis"})
