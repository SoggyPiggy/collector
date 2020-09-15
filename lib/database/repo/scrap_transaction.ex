defmodule Database.Repo.ScrapTransaction do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @transaction_reasons [
    "scrap",
    "repair"
  ]

  schema "scrap_transactions" do
    field :amount, :integer, default: 1
    field :reason, :string

    belongs_to :account, Database.Repo.Account
    belongs_to :coin_instance, Database.Repo.CoinInstance

    timestamps([type: :utc_datetime, updated_at: false])
  end

  def new({:ok, item}, account, params), do: new(item, account, params)
  def new(coin_instance, {:ok, item}, params), do: new(coin_instance, item, params)
  def new(coin_instance, account, {:ok, item}), do: new(coin_instance, account, item)
  def new(coin_instance, account, amount) when is_integer(amount), do: new(account, coin_instance, %{amount: amount})
  def new(%Database.Repo.CoinInstance{} = coin_instance, %Database.Repo.Account{} = account, params) do
    %Database.Repo.ScrapTransaction{}
    |> Database.add_association(account)
    |> Database.add_association(coin_instance)
    |> Changeset.cast(params, [:amount, :reason])
    |> Changeset.validate_required([:amount])
    |> Changeset.validate_inclusion(:reason, @transaction_reasons)
    |> Repo.insert()
  end
  def new(account, coin_instance, params),
    do: new(
      account
      |> Database.Account.get(),
      coin_instance
      |> Database.CoinInstance.get(),
      params
    )

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.ScrapTransaction{} = scrap_transaction), do: scrap_transaction
  def get(id) when is_integer(id) do
    Database.Repo.ScrapTransaction
    |> Database.Repo.get(id)
  end

  def fetch({:ok, item}, key), do: fetch(item, key)
  def fetch(scrap_transaction, key) do
    scrap_transaction
    |> get()
    |> Map.get(key)
  end

  def amount(scrap_transaction) do
    scrap_transaction
    |> fetch(:amount)
  end

  def all() do
    Database.Repo.ScrapTransaction
    |> Database.Repo.all()
  end
  def all(%Database.Repo.CoinInstance{id: id}) do
    [coin_instance_id: id]
    |> all()
  end
  def all(%Database.Repo.Account{id: id}) do
    [account_id: id]
    |> all()
  end
  def all(params) when is_list(params) do
    Database.Repo.ScrapTransaction
    |> Query.where(^params)
    |> Database.Repo.all()
  end
  def all(account) do
    account
    |> Database.Account.get()
    |> all()
  end

  def sum(%Database.Repo.Account{id: id}) do
    Database.Repo.ScrapTransaction
    |> Query.where([account_id: ^id])
    |> Database.Repo.aggregate(:sum, :amount)
  end
  def sum(account) do
    account
    |> sum()
  end
end
