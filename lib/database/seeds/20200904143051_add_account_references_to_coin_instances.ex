defmodule Database.Seeds.AddAccountReferencesToCoinInstances20200904143051 do
  alias Database.{Account, CoinInstance, Repo}

  def version(), do: 20200904143051

  def run() do
    Database.Repo.CoinTransaction
    |> Repo.all()
    |> Enum.each(fn %{amount: amount} = transaction ->
      transaction
      |> add_account(amount, Account.get(transaction))
    end)
  end

  def add_account(coin_instance, 1, account) do
    coin_instance
    |> CoinInstance.owner(account)
  end
  def add_account(coin_instance, -1, _account) do
    coin_instance
    |> CoinInstance.owner(nil)
  end
end
