defmodule Collector do
  alias Collector.Assets

  defdelegate get_asset(item), to: Assets
  defdelegate get_asset(item, file_suffix), to: Assets
  defdelegate get_asset_url(item), to: Assets
  defdelegate get_asset_url(item, file_suffix), to: Assets
end
