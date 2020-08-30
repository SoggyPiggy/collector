import Database

set = create_set(%{name: "Music", folder_dir: "music"})

subset1 = create_set(set, %{name: "Artist", folder_dir: "artists_01"})

subset1 |> create_coin(%{name: "Alex Clare", file_dir: "alex-clare"})
subset1 |> create_coin(%{name: "Matt Shultz", file_dir: "cage"})
subset1 |> create_coin(%{name: "Thomas & Guy", file_dir: "daft"})
subset1 |> create_coin(%{name: "Marshall Mathers", file_dir: "eminem"})
subset1 |> create_coin(%{name: "Emily Haines", file_dir: "metric"})
subset1 |> create_coin(%{name: "Eric Butler", file_dir: "mom-jeans"})
subset1 |> create_coin(%{name: "Max Bemis", file_dir: "say-anything"})
subset1 |> create_coin(%{name: "Julian Casablancas", file_dir: "the-strokes"})
subset1 |> create_coin(%{name: "Oliver Tree", file_dir: "tree"})

subset2 = create_set(set, %{name: "Artist: 2", folder_dir: "artists_02"})

subset2 |> create_coin(%{name: "Gerard Way", file_dir: "chemical"})
subset2 |> create_coin(%{name: "Donald Glover jr", file_dir: "gambino"})
subset2 |> create_coin(%{name: "Lassi Kotamaki", file_dir: "idealism"})
subset2 |> create_coin(%{name: "Gustav Elijah Åhr", file_dir: "lil-peep"})
subset2 |> create_coin(%{name: "Mike Skwark", file_dir: "smrtdeath"})
subset2 |> create_coin(%{name: "Josh & Tyler", file_dir: "top"})
subset2 |> create_coin(%{name: "Tyler", file_dir: "tyler"})
subset2 |> create_coin(%{name: "Mia Vaile", file_dir: "veorra-mia-vaile"})
subset2 |> create_coin(%{name: "Anri du Toit", file_dir: "yolandi"})
