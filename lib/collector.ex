defmodule Collector do
  alias Collector.CoinArt

  defdelegate get_coin_url(coin), to: CoinArt, as: :get_coin_url
  defdelegate get_coin_url(coin, extension), to: CoinArt, as: :get_coin_url
end
