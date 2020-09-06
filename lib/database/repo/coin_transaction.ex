defmodule Database.Repo.CoinTransaction do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @transaction_reasons [
    "collect",
  ]

  schema "coin_transactions" do
    field :amount, :integer, default: 1
    field :reason, :string

    belongs_to :account, Database.Repo.Account
    belongs_to :coin_instance, Database.Repo.CoinInstance

    timestamps([type: :utc_datetime, updated_at: false])
  end

  def new({:ok, item}, account, params), do: new(item, account, params)
  def new(item, {:ok, account}, params), do: new(item, account, params)
  def new(item, account, reason) when is_bitstring(reason),
    do: new(item, account, %{reason: reason})
  def new(%Database.Repo.CoinInstance{} = coin_instance, %Database.Repo.Account{} = account, params) do
    %Database.Repo.CoinTransaction{}
    |> Database.add_association(coin_instance)
    |> Database.add_association(account)
    |> Changeset.cast(params, [:amount, :reason])
    |> Changeset.validate_required([:reason, :account_id, :coin_instance_id])
    |> Changeset.validate_inclusion(:reason, @transaction_reasons)
    |> Repo.insert()
    |> new_adjust_instance(coin_instance, account)
  end
  def new(coin_instance, account, reason),
    do: new(
      coin_instance
      |> Database.CoinInstance.get(),
      account
      |> Database.Account.get(),
      reason
    )

  defp new_adjust_instance({:ok, item}, coin_instance, account), do: new_adjust_instance(item, coin_instance, account)
  defp new_adjust_instance(%Database.Repo.CoinTransaction{amount: 1}, coin_instance, account) do
    coin_instance
    |> Database.CoinInstance.modify(%{account_id: account.id})
  end
  defp new_adjust_instance(%Database.Repo.CoinTransaction{amount: -1}, coin_instance, _account) do
    coin_instance
    |> Database.CoinInstance.modify(%{account_id: nil})
  end

  def fetch(settings, keys) when is_list(keys) do
    keys
    |> Enum.map(fn key ->
      settings
      |> get()
      |> fetch(key)
    end)
  end
  def fetch(settings, key) when is_atom(key) do
    settings
    |> get()
    |> Map.get(key)
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.CoinTransaction{} = coin_transaction), do: coin_transaction
  def get(id) when is_integer(id) do
    Database.Repo.CoinTransaction
    |> Database.Repo.get(id)
  end

  def all() do
    Database.Repo.CoinTransaction
    |> Database.Repo.all()
  end
  def all({:ok, item}), do: all(item)
  def all(%Database.Repo.Account{} = account) do
    [account_id: account.id]
    |> all()
  end
  def all(params) when is_list(params) do
    Database.Repo.CoinTransaction
    |> Query.where(^params)
    |> Database.Repo.all()
  end

  def last({:ok, item}, reason), do: last(item, reason)
  def last(%Database.Repo.Account{} = account, reason) do
    Database.Repo.CoinTransaction
    |> Query.where([account_id: ^account.id, reason: ^reason])
    |> Query.last()
    |> Repo.one()
  end
end
