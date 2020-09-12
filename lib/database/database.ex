defmodule Database do
  alias Database.Seeding
  alias Database.Repo

  defmodule Account do
    defdelegate new(user), to: Repo.Account
    defdelegate get(item), to: Repo.Account
    defdelegate all(), to: Repo.Account
    defdelegate all(params), to: Repo.Account
    defdelegate fetch(item, key), to: Repo.Account
  end

  defmodule AccountSettings do
    defdelegate new(item), to: Repo.AccountSettings
    defdelegate get(item), to: Repo.AccountSettings
    defdelegate all(), to: Repo.AccountSettings
    defdelegate all(params), to: Repo.AccountSettings
    defdelegate fetch(item, key), to: Repo.AccountSettings
    defdelegate modify(item, params), to: Repo.AccountSettings
    defdelegate all?(item, keys), to: Repo.AccountSettings
    defdelegate any?(item, keys), to: Repo.AccountSettings
    defdelegate toggle(item, key), to: Repo.AccountSettings
    defdelegate toggle(item, key, override), to: Repo.AccountSettings
  end

  defmodule Set do
    defdelegate new(params), to: Repo.Set
    defdelegate new(set, params), to: Repo.Set
    defdelegate get(item), to: Repo.Set
    defdelegate get_nested_set(item), to: Repo.Set
    defdelegate all(), to: Repo.Set
    defdelegate all(params), to: Repo.Set
    defdelegate fetch(item, key), to: Repo.Set
    defdelegate modify(set, params), to: Repo.Set
    defdelegate structure(item, key), to: Repo.Set
  end

  defmodule Coin do
    defdelegate new(item, params), to: Repo.Coin
    defdelegate copy(item), to: Repo.Coin
    defdelegate copy(item, params), to: Repo.Coin
    defdelegate all(), to: Repo.Coin
    defdelegate all(params), to: Repo.Coin
    defdelegate get(item), to: Repo.Coin
    defdelegate fetch(item, key), to: Repo.Coin
    defdelegate modify(item, params), to: Repo.Coin
    defdelegate random(), to: Repo.Coin
    defdelegate update_value(item), to: Repo.Coin
  end

  defmodule CoinInstance do
    defdelegate new(item), to: Repo.CoinInstance
    defdelegate new(item, params), to: Repo.CoinInstance
    defdelegate get(item), to: Repo.CoinInstance
    defdelegate all(), to: Repo.CoinInstance
    defdelegate all(params), to: Repo.CoinInstance
    defdelegate fetch(item, key), to: Repo.CoinInstance
    defdelegate modify(item, params), to: Repo.CoinInstance
    defdelegate generate(item), to: Repo.CoinInstance
    defdelegate generate(item, options), to: Repo.CoinInstance
    defdelegate grade(item), to: Repo.CoinInstance
    defdelegate reference(item), to: Repo.CoinInstance
    defdelegate owned?(item), to: Repo.CoinInstance
    defdelegate owner?(item, owner), to: Repo.CoinInstance
    defdelegate owner(item, owner), to: Repo.CoinInstance
    defdelegate update_value(item), to: Repo.CoinInstance
    defdelegate update_value(item, coin), to: Repo.CoinInstance
  end

  defmodule CoinTransaction do
    defdelegate new(item, account, params), to: Repo.CoinTransaction
    defdelegate get(item), to: Repo.CoinTransaction
    defdelegate all(), to: Repo.CoinTransaction
    defdelegate all(params), to: Repo.CoinTransaction
    defdelegate fetch(item, key), to: Repo.CoinTransaction
    defdelegate last(item, reason), to: Repo.CoinTransaction
  end

  defmodule ScrapTransaction do
    defdelegate new(item, account, params), to: Repo.ScrapTransaction
    defdelegate get(item), to: Repo.ScrapTransaction
    defdelegate fetch(item, key), to: Repo.ScrapTransaction
    defdelegate amount(item), to: Repo.ScrapTransaction
    defdelegate all(), to: Repo.ScrapTransaction
    defdelegate all(item), to: Repo.ScrapTransaction
    defdelegate sum(item), to: Repo.ScrapTransaction
  end

  defmodule Suggestion do
    defdelegate new(item, username, content), to: Repo.Suggestion
    defdelegate new(item, params), to: Repo.Suggestion
    defdelegate get(item), to: Repo.Suggestion
    defdelegate all(), to: Repo.Suggestion
    defdelegate all(params), to: Repo.Suggestion
    defdelegate fetch(item, key), to: Repo.Suggestion
    defdelegate reference(item), to: Repo.Suggestion
  end

  defdelegate friendly_coin_value(coin), to: Repo.Utils
  defdelegate add_association(table, association), to: Repo.Utils
  defdelegate preload(table, association), to: Repo.Utils

  defdelegate get_global(key, value_type, default), to: Repo.GlobalSetting, as: :get
  defdelegate set_global(key, value_type, value), to: Repo.GlobalSetting, as: :set

  defdelegate generate_seed(name), to: Seeding.Generator, as: :new
  defdelegate update_seeds(), to: Seeding.Updater, as: :update

end
