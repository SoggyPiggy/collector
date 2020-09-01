defmodule Database.Seeds.CreateInternetStreamers20200901045455 do
  import Database

  def version(), do: 20200901045455

	def run() do
  	set = create_set(%{name: "Internet", folder_dir: "internet"})

    streamers = create_set(set, %{name: "Streamers", folder_dir: "streamers_01"})

    create_coin(streamers, %{name: "CDNthe3rd", file_dir: "ceez"})
    create_coin(streamers, %{name: "Clint Stevens", file_dir: "clint-stevens"})
    create_coin(streamers, %{name: "Corinna Komf", file_dir: "corinna-kopf"})
    create_coin(streamers, %{name: "King Gothalion", file_dir: "gothalion"})
    create_coin(streamers, %{name: "Lirik", file_dir: "lirik"})
    create_coin(streamers, %{name: "Ninja", file_dir: "ninja"})
    create_coin(streamers, %{name: "Pokimane", file_dir: "poki"})
    create_coin(streamers, %{name: "Rubius", file_dir: "rubius"})
    create_coin(streamers, %{name: "Shroud", file_dir: "shroud"})
    create_coin(streamers, %{name: "Sodapoppin", file_dir: "soda"})
    create_coin(streamers, %{name: "Tfue", file_dir: "tfue"})
    create_coin(streamers, %{name: "72hrs", file_dir: "tom"})
  end
end
