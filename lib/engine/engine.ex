defmodule Engine do
  alias Engine.{Assets, CoinHandler}

  defdelegate get_asset(item), to: Assets
  defdelegate get_asset(item, file_suffix), to: Assets
  defdelegate get_asset_url(item), to: Assets
  defdelegate get_asset_url(item, file_suffix), to: Assets

  defdelegate run_collect(account), to: CoinHandler.Collect, as: :run
  defdelegate run_scrap(account, coin_instance, params), to: CoinHandler.Scrap, as: :run
  defdelegate run_repair(account, coin_instance, params), to: CoinHandler.Repair, as: :run
end
