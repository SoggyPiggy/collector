import Database

set =
  create_set(%{name: "Games", folder_dir: "games"})

subset1 = create_set(set, %{name: "Characters", folder_dir: "characters_01"})

subset1 |> create_coin(%{name: "Lahabrea", file_dir: "ascian"})
subset1 |> create_coin(%{name: "Excalibur", file_dir: "excalibur"})
subset1 |> create_coin(%{name: "Fragile", file_dir: "fragile"})
subset1 |> create_coin(%{name: "Link", file_dir: "link"})
subset1 |> create_coin(%{name: "Meat Boy", file_dir: "meat"})
subset1 |> create_coin(%{name: "Tom Nook", file_dir: "nook"})
subset1 |> create_coin(%{name: "PUBG Guy", file_dir: "pubg"})
subset1 |> create_coin(%{name: "Ramirez", file_dir: "ramirez"})
subset1 |> create_coin(%{name: "Steve", file_dir: "steve"})
subset1 |> create_coin(%{name: "Tracer", file_dir: "tracer"})
subset1 |> create_coin(%{name: "Trebuchet", file_dir: "trebuchet"})

subset2 = create_set(set, %{name: "Characters: 2", folder_dir: "characters_02"})

subset1 |> create_coin(%{name: "Agent 47", file_dir: "agent-47"})
subset1 |> create_coin(%{name: "Baldi", file_dir: "baldi"})
subset1 |> create_coin(%{name: "Counter-Terrorist", file_dir: "csgo-ct"})
subset1 |> create_coin(%{name: "Terrorist", file_dir: "csgo-t"})
subset1 |> create_coin(%{name: "The Knight", file_dir: "hallow"})
subset1 |> create_coin(%{name: "Jeanette", file_dir: "jeanette"})
subset1 |> create_coin(%{name: "Pac-man", file_dir: "pacman"})
subset1 |> create_coin(%{name: "Evan MacMillan", file_dir: "trapper"})
