defmodule Database.Seeds.CreateMusicArtists20200901045446 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045446

	def run() do
    set = Set.new(%{name: "Music", folder_dir: "music"})

    artist_1 = Set.new(set, %{name: "Artist", folder_dir: "artists_01"})

    Coin.new(artist_1, %{name: "Alex Clare", file_dir: "alex-clare"})
    Coin.new(artist_1, %{name: "Matt Shultz", file_dir: "cage"})
    Coin.new(artist_1, %{name: "Thomas & Guy", file_dir: "daft"})
    Coin.new(artist_1, %{name: "Marshall Mathers", file_dir: "eminem"})
    Coin.new(artist_1, %{name: "Emily Haines", file_dir: "metric"})
    Coin.new(artist_1, %{name: "Eric Butler", file_dir: "mom-jeans"})
    Coin.new(artist_1, %{name: "Max Bemis", file_dir: "say-anything"})
    Coin.new(artist_1, %{name: "Julian Casablancas", file_dir: "the-strokes"})
    Coin.new(artist_1, %{name: "Oliver Tree", file_dir: "tree"})

    artist_2 = Set.new(set, %{name: "Artist: 2", folder_dir: "artists_02"})

    Coin.new(artist_2, %{name: "Gerard Way", file_dir: "chemical"})
    Coin.new(artist_2, %{name: "Donald Glover jr", file_dir: "gambino"})
    Coin.new(artist_2, %{name: "Lassi Kotamaki", file_dir: "idealism"})
    Coin.new(artist_2, %{name: "Gustav Elijah Åhr", file_dir: "lil-peep"})
    Coin.new(artist_2, %{name: "Mike Skwark", file_dir: "smrtdeath"})
    Coin.new(artist_2, %{name: "Josh & Tyler", file_dir: "top"})
    Coin.new(artist_2, %{name: "Tyler", file_dir: "tyler"})
    Coin.new(artist_2, %{name: "Mia Vaile", file_dir: "veorra-mia-vaile"})
    Coin.new(artist_2, %{name: "Anri du Toit", file_dir: "yolandi"})
  end
end
