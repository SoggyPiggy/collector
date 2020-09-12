defmodule Engine.Assets do
  def get_asset_url(item, file_suffix \\ "")
  def get_asset_url({:ok, item}, file_suffix), do: get_asset_url(item, file_suffix)
  def get_asset_url(item, file_suffix),
    do: Path.join("https://collector.soggypiggy.com/", get_asset(item, file_suffix))

  def get_asset(item, file_suffix \\ "")
  def get_asset({:ok, item}, file_suffix), do: get_asset(item, file_suffix)
  def get_asset(%Database.Repo.Coin{} = coin, file_suffix), do: (
    coin
    |> Database.Set.get()
    |> get_asset("")
    |> Path.join(Map.get(coin, :file_dir))
  ) <> file_suffix
  def get_asset(%Database.Repo.Set{} = set, file_suffix), do: (
    "images/coins"
    |> Path.join(
      set
      |> Database.Set.structure(:folder_dir)
      |> Path.join()
    )
  ) <> file_suffix
  def get_asset(coin, file_suffix) do
    coin
    |> Database.Coin.get()
    |> get_asset(file_suffix)
  end
end
