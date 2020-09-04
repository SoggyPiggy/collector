defmodule Database.Seeds.CreateDiscordClassics20200901045315 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045315

	def run() do
    discord = Set.new(%{name: "Discord", folder_dir: "discord"})

    classics = Set.new(discord, %{name: "Classics", folder_dir: "classics_01"})

    Coin.new(classics, %{name: "CarrotBoi", file_dir: "carrot"})
    Coin.new(classics, %{name: "The Edge", file_dir: "chris"})
    Coin.new(classics, %{name: "Homie", file_dir: "homie"})
    Coin.new(classics, %{name: "NZ Journey", file_dir: "lags-journey"})
    Coin.new(classics, %{name: "lil zebra", file_dir: "lil-dan"})
    Coin.new(classics, %{name: "The Art of Seduction", file_dir: "rp"})
    Coin.new(classics, %{name: "King Weeb", file_dir: "weeb"})
    Coin.new(classics, %{name: "Great Angles", file_dir: "worm"})
    Coin.new(classics, %{name: "Zach & I", file_dir: "zach-i"})
  end
end
