defmodule Database.Repo.Coin do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @modifiable [
    :name,
    :file_dir,
    :in_circulation,
    :weight,
    :value
  ]

  schema "coins" do
    field :name, :string
    field :file_dir, :string, default: "_coin"
    field :in_circulation, :boolean, default: true
    field :weight, :integer, autogenerate: {Enum, :random, [750..1000]}
    field :value, :float, default: 0.0

    belongs_to :set, Database.Repo.Set
    has_many :coin_instances, Database.Repo.CoinInstance
  end

  def new({:ok, item}, params), do: new(item, params)
  def new(item, params) when is_list(params), do: Enum.each(params, fn param -> new(item, param) end)
  def new(%Database.Repo.Set{} = set, params) do
    %Database.Repo.Coin{}
    |> Database.add_association(set)
    |> Changeset.cast(params, @modifiable)
    |> Repo.insert()
  end
  def new(item, params) do
    item
    |> Database.Set.get()
    |> new(params)
  end

  def copy(item, params \\ %{})
  def copy({:ok, item}, params), do: copy(item, params)
  def copy(%Database.Repo.Coin{} = coin, params) do
    coin
    |> Database.Set.get()
    |> new(
      coin
      |> Map.to_list()
      |> List.delete({:__struct__, Database.Repo.Coin})
      |> Map.new()
    )
    |> modify(params)
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.Coin{} = coin), do: coin
  def get(%Database.Repo.CoinInstance{} = coin_instance) do
    coin_instance
    |> Database.preload(:coin)
    |> Map.get(:coin)
  end
  def get(%Database.Repo.CoinTransaction{} = coin_transaction) do
    coin_transaction
    |> Database.CoinInstance.get()
    |> get()
  end
  def get(id) when is_integer(id) do
    Database.Repo.Coin
    |> Database.Repo.get(id)
  end
  def get(name) when is_bitstring(name) do
    Database.Repo.Coin
    |> Query.where(name: ^name)
    |> Repo.one()
  end
  def get(params) when is_list(params) do
    Database.Repo.Coin
    |> Query.where(^params)
    |> Repo.one()
  end

  def all() do
    Database.Repo.Coin
    |> Database.Repo.all()
  end
  def all({:ok, item}), do: all(item)
  def all(params) when is_list(params) do
    Database.Repo.Coin
    |> Query.where(^params)
    |> Database.Repo.all()
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

  def modify({:ok, item}, params), do: modify(item, params)
  def modify(coin, params) do
    coin
    |> get()
    |> Changeset.cast(params, @modifiable)
    |> Repo.update()
  end

  def random() do
    Database.Repo.Coin
    |> Query.where(in_circulation: true)
    |> Query.order_by(desc: :weight)
    |> random_process_query()
    |> random_get_position()
    |> random_search()
  end

  defp random_process_query(query), do: {Repo.all(query), Repo.aggregate(query, :sum, :weight)}
  defp random_get_position({coins, total}), do: {coins, Enum.random(0..total)}
  defp random_search({[coin | tail], rand_pos}, cur_pos \\ 0),
    do: random_search_validate(tail, coin, rand_pos, cur_pos + coin.weight)
  defp random_search_validate([], coin, _rand_pos, _cur_pos), do: coin
  defp random_search_validate(_coins, coin, rand_pos, cur_pos) when cur_pos >= rand_pos, do: coin
  defp random_search_validate(coins, _coin, rand_pos, cur_pos),
    do: random_search({coins, rand_pos}, cur_pos)

  def update_value(coin) do
    coin
    |> get()
    |> update_value(
      Database.Account.all()
      |> Enum.count(),
      coin
      |> get()
      |> Database.CoinInstance.all()
      |> Enum.map(fn instance -> instance.account_id end)
      |> Enum.filter(fn id -> id != nil end)
      |> Enum.uniq()
      |> Enum.count()
    )
  end

  def update_value(%Database.Repo.Coin{} = coin, account_count, owners_count) do
    coin
    |> fetch(:weight)
    |> update_value_weight()
    |> update_value_unique(owners_count, account_count)
    |> update_value_circulation(coin.in_circulation)
    |> update_value_finalize(coin)
  end

  defp update_value_weight(x), do: :math.pow((1000 / x), 3) * 5

  defp update_value_unique(x, 0, _accounts_total), do: x
  defp update_value_unique(x, 1, _accounts_total), do: x
  defp update_value_unique(x, owners_count, accounts_total), do: (
    x * 0.5 * (1 - ((owners_count - 1) / accounts_total))
  ) + (
    x * 0.5
  )

  defp update_value_circulation(x, true), do: x
  defp update_value_circulation(x, false), do: x * 1.2

  defp update_value_finalize(value, coin) do
    coin
    |> modify(%{value: value})
  end
end
