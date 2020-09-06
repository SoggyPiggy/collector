defmodule Database.Seeds.DisableMispelledBrendenCoin20200905020151 do
  alias Database.Coin

  def version(), do: 20200905020151

	def run() do
    "Brenden"
    |> Coin.get()
    |> Coin.modify(%{in_circulation: false})
  end
end
