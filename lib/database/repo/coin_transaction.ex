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
  end
  def new(coin_instance, account, reason),
    do: new(
      coin_instance
      |> Database.CoinInstance.get(),
      account
      |> Database.Account.get(),
      reason
    )

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.CoinTransaction{} = coin_transaction), do: coin_transaction
  def get(id) when is_integer(id) do
    Database.Repo.CoinTransaction
    |> Database.Repo.get(id)
  end

  def last({:ok, item}, reason), do: last(item, reason)
  def last(%Database.Repo.Account{} = account, reason) do
    Database.Repo.CoinTransaction
    |> Query.where([account_id: ^account.id, reason: ^reason])
    |> Query.last()
    |> Repo.one()
  end
end
