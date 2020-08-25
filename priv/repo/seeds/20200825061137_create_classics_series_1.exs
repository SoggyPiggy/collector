import Database

classics =
  create_set(%{name: "Collecting Classics", folder_dir: "classics"})

series_1 =
  classics
  |> create_set(%{name: "Series 1", folder_dir: "001"})

series_1 |> create_coin(%{name: "Zach & I", file_dir: "art-zachandi"})
series_1 |> create_coin(%{name: "CarrotBoi", file_dir: "codey-carrot"})
series_1 |> create_coin(%{name: "Seduced", file_dir: "dnd-rp"})
series_1 |> create_coin(%{name: "Edge", file_dir: "emoji-chris"})
series_1 |> create_coin(%{name: "Moving", file_dir: "lagstrip-lag"})
series_1 |> create_coin(%{name: "King Weeb", file_dir: "weeb-billy"})
series_1 |> create_coin(%{name: "Homie", file_dir: "yokio-homie"})
series_1 |> create_coin(%{name: "lil zebra", file_dir: "young-dan"})
series_1 |> create_coin(%{name: "The Worm", file_dir: "zach-worm"})
