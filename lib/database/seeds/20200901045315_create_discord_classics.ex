defmodule Database.Seeds.CreateDiscordClassics20200901045315 do
  import Database

  def version(), do: 20200901045315

	def run() do
    discord = create_set(%{name: "Discord", folder_dir: "discord"})

    classics = create_set(discord, %{name: "Classics", folder_dir: "classics_01"})

    create_coin(classics, %{name: "CarrotBoi", file_dir: "carrot"})
    create_coin(classics, %{name: "The Edge", file_dir: "chris"})
    create_coin(classics, %{name: "Homie", file_dir: "homie"})
    create_coin(classics, %{name: "NZ Journey", file_dir: "lags-journey"})
    create_coin(classics, %{name: "lil zebra", file_dir: "lil-dan"})
    create_coin(classics, %{name: "The Art of Seduction", file_dir: "rp"})
    create_coin(classics, %{name: "King Weeb", file_dir: "weeb"})
    create_coin(classics, %{name: "Great Angles", file_dir: "worm"})
    create_coin(classics, %{name: "Zach & I", file_dir: "zach-i"})
  end
end
