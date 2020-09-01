defmodule Database.Seeds.CreateMusicArtists20200901045446 do
  import Database

  def version(), do: 20200901045446

	def run() do
    set = create_set(%{name: "Music", folder_dir: "music"})

    artist_1 = create_set(set, %{name: "Artist", folder_dir: "artists_01"})

    create_coin(artist_1, %{name: "Alex Clare", file_dir: "alex-clare"})
    create_coin(artist_1, %{name: "Matt Shultz", file_dir: "cage"})
    create_coin(artist_1, %{name: "Thomas & Guy", file_dir: "daft"})
    create_coin(artist_1, %{name: "Marshall Mathers", file_dir: "eminem"})
    create_coin(artist_1, %{name: "Emily Haines", file_dir: "metric"})
    create_coin(artist_1, %{name: "Eric Butler", file_dir: "mom-jeans"})
    create_coin(artist_1, %{name: "Max Bemis", file_dir: "say-anything"})
    create_coin(artist_1, %{name: "Julian Casablancas", file_dir: "the-strokes"})
    create_coin(artist_1, %{name: "Oliver Tree", file_dir: "tree"})

    artist_2 = create_set(set, %{name: "Artist: 2", folder_dir: "artists_02"})

    create_coin(artist_2, %{name: "Gerard Way", file_dir: "chemical"})
    create_coin(artist_2, %{name: "Donald Glover jr", file_dir: "gambino"})
    create_coin(artist_2, %{name: "Lassi Kotamaki", file_dir: "idealism"})
    create_coin(artist_2, %{name: "Gustav Elijah Åhr", file_dir: "lil-peep"})
    create_coin(artist_2, %{name: "Mike Skwark", file_dir: "smrtdeath"})
    create_coin(artist_2, %{name: "Josh & Tyler", file_dir: "top"})
    create_coin(artist_2, %{name: "Tyler", file_dir: "tyler"})
    create_coin(artist_2, %{name: "Mia Vaile", file_dir: "veorra-mia-vaile"})
    create_coin(artist_2, %{name: "Anri du Toit", file_dir: "yolandi"})
  end
end
