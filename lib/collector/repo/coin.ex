defmodule Collector.Repo.Coin do
  alias Collector.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "coins" do
    field :name, :string
    field :file_dir, :string, default: "_coin"
    field :in_circulation, :boolean, default: true
    field :weight, :integer, autogenerate: {Enum, :random, [50..100]}

    belongs_to :category, Collector.Repo.Category
    has_many :coin_instances, Collector.Repo.CoinInstance
  end

  def create(category, params) do
    %Collector.Repo.Coin{}
    |> Repo.add_association(category)
    |> Changeset.cast(params, [:name, :file_dir, :in_circulation, :weight])
    |> Repo.insert()
  end

  def update(coin, params) do
    coin
    |> Changeset.cast(params, [:name, :file_dir, :in_circulation])
    |> Repo.update()
  end

  def get_by_id(id) do
    Collector.Repo.Coin
    |> Query.where(id: ^id)
    |> Repo.one()
  end

  def get_by_name(name) do
    Collector.Repo.Coin
    |> Query.where(name: ^name)
    |> Repo.one()
  end

  def select_random() do
    Collector.Repo.Coin
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
    coin
    |> Collector.Repo.preload(:category)
    |> get_art_path_get_path()
  end

  defp get_art_path_get_path(%{file_dir: file_dir, category: %{folder_dir: folder_dir}}) do
    File.cwd!()
    |> Path.join("assets")
    |> Path.join(folder_dir)
    |> Path.join(file_dir)
  end
end
