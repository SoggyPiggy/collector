defmodule Database.Seeds.AddErrorToErrorCoins20200924183805 do
  alias Database.Coin

  def version(), do: 20200924183805

	def run() do
    [name: "Brenden"]
    |> Coin.get()
    |> Coin.modify(%{is_error: true})

    [name: "Caste Separation Protest", file_dir: "fall-of-constantinople"]
    |> Coin.get()
    |> Coin.modify(%{is_error: true})

    [name: "The Fall of Constantinople", file_dir: "normandy"]
    |> Coin.get()
    |> Coin.modify(%{is_error: true})

    [name: "Hidenburg", file_dir: "ghandi-caste-seperation"]
    |> Coin.get()
    |> Coin.modify(%{is_error: true})

    [name: "D-Day", file_dir: "hidenburg"]
    |> Coin.get()
    |> Coin.modify(%{is_error: true})
  end
end
