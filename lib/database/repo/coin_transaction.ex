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

  def create({:ok, coin_instance}, account, params), do: create(coin_instance, account, params)
  def create(coin_instance, {:ok, account}, params), do: create(coin_instance, account, params)
  def create(coin_instance, account, params) do
    %Database.Repo.CoinTransaction{}
    |> Repo.add_association(coin_instance)
    |> Repo.add_association(account)
    |> Changeset.cast(params, [:amount, :reason])
    |> Changeset.validate_required([:reason, :account_id, :coin_instance_id])
    |> Changeset.validate_inclusion(:reason, @transaction_reasons)
    |> Repo.insert()
  end

  def get_last(account, reason) do
    Database.Repo.CoinTransaction
    |> Query.where([account_id: ^account.id, reason: ^reason])
    |> Query.last()
    |> Repo.one()
  end
end