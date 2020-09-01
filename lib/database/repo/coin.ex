defmodule Database.Repo.Coin do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "coins" do
    field :name, :string
    field :file_dir, :string, default: "_coin"
    field :in_circulation, :boolean, default: true
    field :weight, :integer, autogenerate: {Enum, :random, [750..1000]}

    belongs_to :set, Database.Repo.Set
    has_many :coin_instances, Database.Repo.CoinInstance
  end

  def create({:ok, set}, params), do: create(set, params)
  def create(set, params) do
    %Database.Repo.Coin{}
    |> Database.add_association(set)
    |> Changeset.cast(params, [:name, :file_dir, :in_circulation, :weight])
    |> Repo.insert()
  end

  def update(coin, params) do
    coin
    |> Changeset.cast(params, [:name, :file_dir, :in_circulation])
    |> Repo.update()
  end

  def get_by_id(id) do
    Database.Repo.Coin
    |> Query.where(id: ^id)
    |> Repo.one()
  end

  def get_by_name(name) do
    Database.Repo.Coin
    |> Query.where(name: ^name)
    |> Repo.one()
  end

  def select_random() do
    Database.Repo.Coin
    |> Query.where(in_circulation: true)
    |> Query.order_by(desc: :weight)
    |> select_random_process_query()
    |> select_random_get_position()
    |> select_random_search()
  end

  defp select_random_process_query(query), do: {Repo.all(query), Repo.aggregate(query, :sum, :weight)}
  defp select_random_get_position({coins, total}), do: {coins, Enum.random(0..total)}
  defp select_random_search({[coin | tail], rand_pos}, cur_pos \\ 0),
    do: select_random_search_validate(tail, coin, rand_pos, cur_pos + coin.weight)
  defp select_random_search_validate([], coin, _rand_pos, _cur_pos), do: coin
  defp select_random_search_validate(_coins, coin, rand_pos, cur_pos) when cur_pos >= rand_pos, do: coin
  defp select_random_search_validate(coins, _coin, rand_pos, cur_pos),
    do: select_random_search({coins, rand_pos}, cur_pos)

  def get_art_path(coin, ext), do: get_art_path(coin) <> ext
  def get_art_path(coin) do
    "/images/coins"
    |> get_art_path_append_parent_dir(coin)
    |> Path.join(coin.file_dir)
  end

  defp get_art_path_append_parent_dir(path, %{set_id: nil}), do: path
  defp get_art_path_append_parent_dir(path, child) do
    parent =
      child
      |> Repo.preload(:set)
      |> Map.get(:set)

    path
    |> get_art_path_append_parent_dir(parent)
    |> Path.join(parent.folder_dir)
  end

  def get_set_structure(child, tail \\ [])
  def get_set_structure(%Database.Repo.Coin{} = coin, tail) do
    coin
    |> Repo.preload(:set)
    |> Map.get(:set)
    |> get_set_structure(tail)
  end
  def get_set_structure(%Database.Repo.Set{set_id: nil, name: name}, tail), do: [name | tail]
  def get_set_structure(%Database.Repo.Set{name: name} = child, tail) do
    child
    |> Repo.preload(:set)
    |> Map.get(:set)
    |> get_set_structure([name | tail])
  end
end
