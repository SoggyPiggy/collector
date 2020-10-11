defmodule Database.Seeds.AddYokaiSeries20201009061651 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061651

  def run() do
    [name: "Bestiary", folder_dir: "bestiary"]
    |> Set.get()
    |> Set.new(%{name: "Yokai", folder_dir: "yokai_01"})
    |> Coin.new(%{name: "Kejōrō", file_dir: "kejourou"})
    |> Coin.new(%{name: "Kyōkotsu", file_dir: "kyoukotsu"})
    |> Coin.new(%{name: "Tesso", file_dir: "tesso"})
  end
end
