defmodule Collector do
  alias Collector.{Assets, CoinHandler}

  defdelegate get_asset(item), to: Assets
  defdelegate get_asset(item, file_suffix), to: Assets
  defdelegate get_asset_url(item), to: Assets
  defdelegate get_asset_url(item, file_suffix), to: Assets

  defdelegate collect_coin(account), to: CoinHandler
  defdelegate scrap_coin(coin_instance), to: CoinHandler
  defdelegate scrap_coin_estimate(coin_instance), to: CoinHandler
end
