import Database

set = create_set(%{name: "Internet", folder_dir: "internet"})

subset = create_set(set, %{name: "Streamers", folder_dir: "streamers_01"})

subset |> create_coin(%{name: "CDNthe3rd", file_dir: "ceez"})
subset |> create_coin(%{name: "Clint Stevens", file_dir: "clint-stevens"})
subset |> create_coin(%{name: "Corinna Komf", file_dir: "corinna-kopf"})
subset |> create_coin(%{name: "King Gothalion", file_dir: "gothalion"})
subset |> create_coin(%{name: "Lirik", file_dir: "lirik"})
subset |> create_coin(%{name: "Ninja", file_dir: "ninja"})
subset |> create_coin(%{name: "Pokimane", file_dir: "poki"})
subset |> create_coin(%{name: "Rubius", file_dir: "rubius"})
subset |> create_coin(%{name: "Shroud", file_dir: "shroud"})
subset |> create_coin(%{name: "Sodapoppin", file_dir: "soda"})
subset |> create_coin(%{name: "Tfue", file_dir: "tfue"})
subset |> create_coin(%{name: "72hrs", file_dir: "tom"})
