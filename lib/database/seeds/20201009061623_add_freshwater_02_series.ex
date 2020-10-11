defmodule Database.Seeds.AddFreshwater02Series20201009061623 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061623

  def run() do
    [name: "Aquatic Life", folder_dir: "aquatics"]
    |> Set.get()
    |> Set.new(%{name: "More Fish", folder_dir: "freshwater_02"})
    |> Coin.new(%{name: "Galaxy Rasbora", file_dir: "celestial-pearl-danio"})
  end
end
