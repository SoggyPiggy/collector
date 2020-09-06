defmodule Database.Seeds.FixPreviousFuckups20200906203549 do
  alias Database.Coin

  def version(), do: 20200906203549

	def run() do
    [name: "Brenden"]
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
    |> Coin.copy(%{in_circulation: true, name: "Brendan"})

    [name: "Caste Separation Protest", file_dir: "fall-of-constantinople"]
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
    |> Coin.copy(%{in_circulation: true, name: "The Fall of Constantinople"})

    [name: "The Fall of Constantinople", file_dir: "normandy"]
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
    |> Coin.copy(%{in_circulation: true, name: "D-Day"})

    [name: "Hidenburg", file_dir: "ghandi-caste-seperation"]
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
    |> Coin.copy(%{in_circulation: true, name: "Caste Separation Protest"})

    [name: "D-Day", file_dir: "hidenburg"]
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
    |> Coin.copy(%{in_circulation: true, name: "Hindenburg"})
  end
end
