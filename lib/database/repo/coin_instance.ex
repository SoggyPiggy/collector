defmodule Database.Repo.CoinInstance do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @modifiables [
    :condition,
    :condition_natural,
    :condition_roll,
    :is_altered,
    :account_id,
    :value
  ]

  schema "coin_instances" do
    field :condition, :float
    field :condition_natural, :float
    field :condition_roll, :float
    field :is_altered, :boolean
    field :value, :float, default: 0.0

    belongs_to :coin, Database.Repo.Coin
    belongs_to :account, Database.Repo.Account
    has_many :coin_transactions, Database.Repo.CoinTransaction

    timestamps([type: :utc_datetime])
  end

  def new(item, params \\ %{})
  def new({:ok, item}, params), do: new(item, params)
  def new(%Database.Repo.Coin{} = coin, params) do
    %Database.Repo.CoinInstance{}
    |> Database.add_association(coin)
    |> Changeset.cast(params, @modifiables)
    |> Changeset.validate_required([:condition])
    |> Repo.insert()
  end
  def new(coin, params) do
    coin
    |> Database.Coin.get()
    |> new(params)
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.CoinInstance{} = coin_instance), do: coin_instance
  def get(%Database.Repo.CoinTransaction{} = coin_transaction) do
    coin_transaction
    |> Database.preload(:coin_instance)
    |> Map.get(:coin_instance)
  end
  def get(%Database.Repo.ScrapTransaction{} = coin_transaction) do
    coin_transaction
    |> Database.preload(:coin_instance)
    |> Map.get(:coin_instance)
  end
  def get(id) when is_integer(id) do
    Database.Repo.CoinInstance
    |> Database.Repo.get(id)
  end
  def get(id) when is_bitstring(id) do
    id
    |> String.to_integer(36)
    |> get()
  end
  def get(params) when is_list(params) do
    Database.Repo.Coin
    |> Query.where(^params)
    |> Repo.one()
  end

  def all() do
    Database.Repo.CoinInstance
    |> Database.Repo.all()
  end
  def all({:ok, item}), do: all(item)
  def all(%Database.Repo.Account{} = account) do
    [account_id: account.id]
    |> all()
  end
  def all(%Database.Repo.Coin{} = coin) do
    [coin_id: coin.id]
    |> all()
  end
  def all(params) when is_list(params) do
    Database.Repo.CoinInstance
    |> Query.where(^params)
    |> Database.Repo.all()
  end

  def fetch(coin_instance, keys) when is_list(keys) do
    keys
    |> Enum.map(fn key ->
      coin_instance
      |> get()
      |> fetch(key)
    end)
  end
  def fetch(coin_instance, key) when is_atom(key) do
    coin_instance
    |> get()
    |> Map.get(key)
  end

  def generate(item, params \\ %{})
  def generate({:ok, item}, params), do: generate(item, params)
  def generate(coin, params) do
    condition_roll = Map.get(params, :seeder, &:rand.uniform/0).()
    condition =
      condition_roll
      |> fn value -> value * Map.get(params, :pre_multiplier, 1) end.()
      |> fn value -> value + Map.get(params, :pre_addition, 0) end.()
      |> Map.get(params, :processor, &generate_condition/1).()
      |> fn value -> value * Map.get(params, :post_multiplier, 1) end.()
      |> fn value -> value + Map.get(params, :post_addition, 0) end.()

    coin
    |> Database.Coin.get()
    |> new(%{
      condition: condition,
      condition_natural: condition,
      condition_roll: condition_roll,
      value: Database.Coin.fetch(coin, :value) * condition
    })
  end

  defp generate_condition(0), do: 0
  defp generate_condition(1), do: 1
  defp generate_condition(x) when x < 0.5, do: 1 - generate_condition(1 - x)
  defp generate_condition(x), do: (:math.pow(2 * x - 1, 2.2) / 2) + 0.5

  def modify(item, params \\ %{})
  def modify({:ok, item}, params), do: modify(item, params)
  def modify(coin_instance, params) do
    coin_instance
    |> get()
    |> Changeset.cast(params, @modifiables)
    |> Changeset.validate_required([:condition])
    |> Database.Repo.update()
  end

  def reference({:ok, item}), do: reference(item)
  def reference(coin_instance) do
    coin_instance
    |> get()
    |> Map.get(:id)
    |> Integer.to_string(36)
    |> String.pad_leading(4, "0")
  end

  def grade({:ok, item}), do: grade(item)
  def grade(coin_instance) do
    coin_instance
    |> get()
    |> Map.get(:condition)
    |> case do
      x when x >= 1.00 -> "Mint"
      x when x >= 0.95 -> "Mint-"
      x when x >= 0.85 -> "Good+"
      x when x >= 0.75 -> "Good"
      x when x >= 0.65 -> "Good-"
      x when x >= 0.55 -> "Average+"
      x when x >= 0.45 -> "Average"
      x when x >= 0.35 -> "Average-"
      x when x >= 0.25 -> "Bad+"
      x when x >= 0.15 -> "Bad"
      x when x >= 0.05 -> "Bad-"
      x when x >  0.00 -> "Terrible"
      _                -> "Cum Ridden"
    end
  end

  def owned?(coin_instance), do: (
    coin_instance
    |> fetch(:account_id)
  ) != nil

  def owner?(coin_instance, account), do: (
    coin_instance
    |> fetch(:account_id)
  ) == (
    account
    |> Database.Account.fetch(:id)
  )

  def owner({:ok, item}, account), do: owner(item, account)
  def owner(coin_instance, {:ok, item}), do: owner(coin_instance, item)
  def owner(coin_instance, %Database.Repo.Account{} = account) do
    coin_instance
    |> get()
    |> Map.put(:account, account)
    |> modify(%{account_id: account.id})
  end
  def owner(coin_instance, nil) do
    coin_instance
    |> get()
    |> Map.put(:account, nil)
    |> modify(%{account_id: nil})
  end

  def value_raw(%Database.Repo.CoinInstance{} = coin_instance) do
    coin_instance
    |> Database.Coin.get()
    |> Database.Coin.fetch(:value)
    |> value_raw_condition_modifier(coin_instance.condition)
    |> value_raw_altered_modifier(coin_instance.is_altered)
    |> value_raw_circulation_modifier(Database.Coin.fetch(coin_instance, :in_circulation))
    |> value_raw_error_modifier(Database.Coin.fetch(coin_instance, :is_error))
  end
  def value_raw(coin_instance) do
    coin_instance
    |> Database.CoinInstance.get()
    |> value_raw()
  end

  defp value_raw_condition_modifier(value, 0), do: value * 1.5
  defp value_raw_condition_modifier(value, condition), do: (
    value * 0.1
  ) * (
    value * 0.9 * condition
  )

  defp value_raw_altered_modifier(value, true), do: value * 0.8
  defp value_raw_altered_modifier(value, _), do: value

  defp value_raw_circulation_modifier(value, false), do: value * 1.2
  defp value_raw_circulation_modifier(value, _), do: value

  defp value_raw_error_modifier(value, true), do: value * 1.8
  defp value_raw_error_modifier(value, _), do: value

  def update_value(coin_instance) do
    coin_instance
    |> modify(%{value: value_raw(coin_instance)})
  end
end
