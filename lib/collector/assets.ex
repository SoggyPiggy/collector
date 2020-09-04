defmodule Collector.Assets do
  def get_asset_url(item, file_suffix \\ "")
  def get_asset_url({:ok, item}, file_suffix), do: get_asset_url(item, file_suffix)
  def get_asset_url(item, file_suffix),
    do: Path.join("https://collector.soggypiggy.com/", get_asset(item, file_suffix))

  def get_asset(item, file_suffix \\ "")
  def get_asset({:ok, item}, file_suffix), do: get_asset(item, file_suffix)
  def get_asset(%Database.Repo.Coin{} = coin, file_suffix), do: Path.join(
    get_asset(Database.Set.get(coin), ""),
    Map.get(coin, :file_dir)
  ) <> file_suffix
  def get_asset(%Database.Repo.Set{} = set, file_suffix), do: (
    set
    |> Database.Set.structure(:folder_dir)
    |> Path.join()
  ) <> file_suffix
end
