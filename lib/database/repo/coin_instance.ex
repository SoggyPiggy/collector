defmodule Database.Repo.CoinInstance do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "coin_instances" do
    field :condition, :float

    belongs_to :coin, Database.Repo.Coin
    has_many :coin_transactions, Database.Repo.CoinTransaction

    timestamps([type: :utc_datetime])
  end

  def new(item, params \\ %{})
  def new({:ok, item}, params), do: new(item, params)
  def new(%Database.Repo.Coin{} = coin, params) do
    %Database.Repo.CoinInstance{}
    |> Database.add_association(coin)
    |> Changeset.cast(params, [:condition])
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

  def generate(item, params \\ %{})
  def generate({:ok, item}, params), do: generate(item, params)
  def generate(coin, params) do
    coin
    |> Database.Coin.get()
    |> new(%{condition:
      Map.get(params, :seeder, &:rand.uniform/0).()
      |> fn value -> value * Map.get(params, :pre_multiplier, 1) end.()
      |> fn value -> value + Map.get(params, :pre_addition, 0) end.()
      |> Map.get(params, :processor, &generate_condition/1).()
      |> fn value -> value * Map.get(params, :post_multiplier, 1) end.()
      |> fn value -> value + Map.get(params, :post_addition, 0) end.()
    })
  end

  defp generate_condition(value), do: (:math.pow(2 * value - 1, 3) / 2) + 0.5

  def grade({:ok, item}), do: grade(item)
  def grade(coin_instance) do
    coin_instance
    |> get()
    |> Map.get(:condition)
    |> case do
      x when x > 0.95 -> "About Uncirculated"
      x when x > 0.90 -> "Extremely Fine"
      x when x > 0.75 -> "Very Fine"
      x when x > 0.70 -> "Fine"
      x when x > 0.50 -> "Very Good"
      x when x > 0.25 -> "Good"
      x when x > 0.20 -> "About Good"
      x when x > 0.10 -> "Fair"
      _ -> "Poor"
    end
  end
end
