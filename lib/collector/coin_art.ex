defmodule Collector.CoinArt do
  def get_coin_url(%Database.Repo.Coin{} = coin, extension \\ ".png") do
    "https://collector.soggypiggy.com/"
    |> Path.join(Database.get_coin_art_path(coin, extension))
  end
end
