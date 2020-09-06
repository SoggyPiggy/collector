defmodule Database.AccountSettingsTest do
  use Collector.DataCase, async: true

  alias Database.{Account, AccountSettings, Repo}

  test "database account_settings new" do
    account = Account.new(0)
    assert {:ok, %Repo.AccountSettings{}} = AccountSettings.new(account)
    assert {:error, _changeset_error} = AccountSettings.new(account)
  end

  test "database account_settings get" do
    account = Account.new(0)
    assert {:ok, %Repo.AccountSettings{}} = AccountSettings.get(account)
    assert %Repo.AccountSettings{} = AccountSettings.get(account)
  end
end
