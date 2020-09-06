defmodule Database.AccountTest do
  use Collector.DataCase, async: true

  alias Database.{Account, Repo}

  test "database account new" do
    assert {:ok, %Repo.Account{discord_id: 0}} = Account.new(0)
    assert {:ok, %Repo.Account{discord_id: 2}} = Account.new(%Nostrum.Struct.User{id: 2})
    assert {:error, _changeset_error} = Account.new(0)
  end

  test "database account get" do
    assert {:ok, account} = Account.new(0)
    assert %Repo.Account{} = Account.get(0)
    assert %Repo.Account{} = Account.get(%Nostrum.Struct.User{id: 0})
    assert %Repo.Account{} = Account.get(%Nostrum.Struct.Message{author: %Nostrum.Struct.User{id: 0}})
    assert %Repo.Account{} = Account.get(%Repo.CoinInstance{account_id: account.id})
    assert %Repo.Account{} = Account.get(%Repo.CoinTransaction{account_id: account.id})
    assert %Repo.Account{} = Account.get(%Repo.Suggestion{account_id: account.id})
    assert {nil} = {Account.get(1)}
  end
end
