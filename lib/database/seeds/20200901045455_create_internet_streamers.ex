defmodule Database.Seeds.CreateInternetStreamers20200901045455 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045455

	def run() do
  	set = Set.new(%{name: "Internet", folder_dir: "internet"})

    streamers = Set.new(set, %{name: "Streamers", folder_dir: "streamers_01"})

    Coin.new(streamers, %{name: "CDNthe3rd", file_dir: "ceez"})
    Coin.new(streamers, %{name: "Clint Stevens", file_dir: "clint-stevens"})
    Coin.new(streamers, %{name: "Corinna Komf", file_dir: "corinna-kopf"})
    Coin.new(streamers, %{name: "King Gothalion", file_dir: "gothalion"})
    Coin.new(streamers, %{name: "Lirik", file_dir: "lirik"})
    Coin.new(streamers, %{name: "Ninja", file_dir: "ninja"})
    Coin.new(streamers, %{name: "Pokimane", file_dir: "poki"})
    Coin.new(streamers, %{name: "Rubius", file_dir: "rubius"})
    Coin.new(streamers, %{name: "Shroud", file_dir: "shroud"})
    Coin.new(streamers, %{name: "Sodapoppin", file_dir: "soda"})
    Coin.new(streamers, %{name: "Tfue", file_dir: "tfue"})
    Coin.new(streamers, %{name: "72hrs", file_dir: "tom"})
  end
end
