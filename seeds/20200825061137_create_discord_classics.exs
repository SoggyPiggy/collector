import Database

classics =
  create_set(%{name: "Discord", folder_dir: "discord"})

series_1 =
  classics
  |> create_set(%{name: "Classics", folder_dir: "classics_01"})

series_1 |> create_coin(%{name: "CarrotBoi", file_dir: "carrot"})
series_1 |> create_coin(%{name: "The Edge", file_dir: "chris"})
series_1 |> create_coin(%{name: "Homie", file_dir: "homie"})
series_1 |> create_coin(%{name: "NZ Journey", file_dir: "lags-journey"})
series_1 |> create_coin(%{name: "lil zebra", file_dir: "lil-dan"})
series_1 |> create_coin(%{name: "The Art of Seduction", file_dir: "rp"})
series_1 |> create_coin(%{name: "King Weeb", file_dir: "weeb"})
series_1 |> create_coin(%{name: "Great Angles", file_dir: "worm"})
series_1 |> create_coin(%{name: "Zach & I", file_dir: "zach-i"})
