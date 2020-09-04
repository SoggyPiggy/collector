defmodule Database.Seeds.FixMispellings20200902230620 do
  alias Database.Coin

  def version(), do: 20200902230620

  def run() do
    "Spotted Blue Eye"
    |> Coin.get()
    |> Coin.modify(%{file_dir: "gertrudes-rainbow"})

    "Burmese Dwarf Stickleback"
    |> Coin.get()
		|> Coin.modify(%{file_dir: "paradoxus-toothpick"})

    "Scarlet Badis"
    |> Coin.get()
		|> Coin.modify(%{file_dir: "scarlet-badis"})

    "Woodstock '69"
    |> Coin.get()
		|> Coin.modify(%{file_dir: "woodstock"})
  end
end
