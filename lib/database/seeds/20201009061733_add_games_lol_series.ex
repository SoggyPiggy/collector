defmodule Database.Seeds.AddGamesLolSeries20201009061733 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061733

  def run() do
    [name: "Games", folder_dir: "games"]
    |> Set.get()
    |> Set.new(%{name: "League", folder_dir: "lol"})
    |> Coin.new(%{name: "Brand", file_dir: "brand"})
    |> Coin.new(%{name: "Fizz", file_dir: "fizz"})
    |> Coin.new(%{name: "Heimerdinger", file_dir: "heimerdinger"})
    |> Coin.new(%{name: "Jinx", file_dir: "jinx"})
    |> Coin.new(%{name: "Riven", file_dir: "riven"})
    |> Coin.new(%{name: "Singed", file_dir: "singed"})
    |> Coin.new(%{name: "Teemo", file_dir: "teemo"})
    |> Coin.new(%{name: "Vi", file_dir: "vi"})
  end
end
