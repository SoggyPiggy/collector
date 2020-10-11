defmodule Database.Seeds.AddInternetStreamersSeries20201009061839 do
  alias Database.{Coin, Set}

  def version(), do: 20201009061839

  def run() do
    [name: "Internet", folder_dir: "internet"]
    |> Set.get()
    |> Set.new(%{name: "Streamers: 2", folder_dir: "streamers_02"})
    |> Coin.new(%{name: "Quin69", file_dir: "quin"})
  end
end
