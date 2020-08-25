defmodule Database do
  alias Database.Repo.{
    Account,
    AccountSettings,
    Set,
    Coin,
    CoinInstance,
    CoinTransaction,
    Utils,
    Suggestion,
    GlobalSetting
  }

  defdelegate create_account(user), to: Account, as: :create
  defdelegate get_account_by_discord_user(user), to: Account, as: :get_by_discord_user
  defdelegate get_account_by_discord_id(id), to: Account, as: :get_by_discord_id

  defdelegate create_account_settings(account), to: AccountSettings, as: :create
  defdelegate get_account_settings(account), to: AccountSettings, as: :get
  defdelegate has_admin_override(settings), to: AccountSettings
  defdelegate toggle_admin(account), to: AccountSettings
  defdelegate make_admin(account), to: AccountSettings

  defdelegate create_set(params), to: Set, as: :create
  defdelegate get_set_by_card(card), to: Set, as: :get_by_card
  defdelegate get_set_by_id(id), to: Set, as: :get_by_id
  defdelegate get_set_by_name(name), to: Set, as: :get_by_name

  defdelegate create_coin(set, params), to: Coin, as: :create
  defdelegate get_coin_by_id(id), to: Coin, as: :get_by_id
  defdelegate get_coin_by_name(name), to: Coin, as: :get_by_name
  defdelegate select_random_coin(), to: Coin, as: :select_random
  defdelegate get_coin_art_path(coin), to: Coin, as: :get_art_path
  defdelegate get_coin_art_path(coin, file_extension), to: Coin, as: :get_art_path

  defdelegate create_coin_instance(coin, condition), to: CoinInstance, as: :create
  defdelegate generate_coin_instance(coin), to: CoinInstance, as: :generate
  defdelegate generate_coin_instance(coin, params), to: CoinInstance, as: :generate

  defdelegate create_coin_transaction(coin_instance, account, params), to: CoinTransaction, as: :create
  defdelegate get_last_coin_transaction(account, reason), to: CoinTransaction, as: :get_last

  defdelegate create_suggestion(account, params), to: Suggestion, as: :create

  defdelegate add_association(table, association), to: Utils

  defdelegate get_seeding_version(), to: GlobalSetting
  defdelegate set_seeding_version(value), to: GlobalSetting

  defdelegate preload(table, association), to: Database.Repo
end
