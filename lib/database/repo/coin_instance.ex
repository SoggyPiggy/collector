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
      x when x >= 0.95 -> "Excellent"
      x when x >= 0.85 -> "Great"
      x when x >= 0.75 -> "Good"
      x when x >= 0.65 -> "Decent"
      x when x >= 0.55 -> "Fair"
      x when x >= 0.45 -> "Average"
      x when x >= 0.35 -> "Mediocre"
      x when x >= 0.25 -> "Poor"
      x when x >= 0.15 -> "Bad"
      x when x >= 0.05 -> "Terrible"
      x when x >  0.00 -> "Abysmal"
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

  def update_value(coin_instance) do
    coin_instance
    |> get()
    |> update_value(
      coin_instance
      |> get()
      |> Database.Coin.get()
    )
  end
  def update_value(coin_instance, coin) do
    coin_instance
    |> get()
    |> modify(%{
      value: (
        coin
        |> Database.Coin.fetch(:value)
      ) * (
        coin_instance
        |> fetch(:condition)
      )
    })
  end
end
