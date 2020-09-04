defmodule Database.Repo.Set do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @modifiable [
    :name,
    :folder_dir
  ]

  schema "sets" do
    field :name, :string
    field :folder_dir, :string, default: "_default"

    belongs_to :set, Database.Repo.Set
    has_many :sets, Database.Repo.Set
    has_many :coins, Database.Repo.Coin
  end

  def new(params), do: new(nil, params)
  def new({:ok, item}, params), do: new(item, params)
  def new(%Database.Repo.Set{} = set, params) do
    %Database.Repo.Set{}
    |> Database.add_association(set)
    |> Changeset.cast(params, @modifiable)
    |> Repo.insert()
  end
  def new(nil, params) do
    %Database.Repo.Set{}
    |> Changeset.cast(params, @modifiable)
    |> Repo.insert()
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.Set{} = set), do: set
  def get(%Database.Repo.Coin{} = coin) do
    coin
    |> Database.preload(:set)
    |> Map.get(:set)
  end
  def get(id) when is_integer(id) do
    Database.Repo.Set
    |> Database.Repo.get(id)
  end
  def get(name) when is_bitstring(name) do
    Database.Repo.Set
    |> Query.where(name: ^name)
    |> Repo.one()
  end
  def get(item) do
    item
    |> Database.Coin.get()
    |> get()
  end

  def get_nested_set({:ok, item}), do: get_nested_set(item)
  def get_nested_set(set) do
    set
    |> get()
    |> Database.preload(:set)
    |> Map.get(:set)
  end

  def modify({:ok, item}, params), do: modify(item, params)
  def modify(set, params) do
    set
    |> get()
    |> Changeset.cast(params, @modifiable)
    |> Repo.update()
  end

  def structure(item, key, tail \\ [])
  def structure({:ok, item}, key, tail), do: structure(item, key, tail)
  def structure(%Database.Repo.Set{set_id: nil} = set, key, tail), do: [Map.get(set, key) | tail]
  def structure(%Database.Repo.Set{} = set, key, tail) do
    set
    |> get_nested_set()
    |> structure(key, [Map.get(set, key) | tail])
  end
  def structure(set, key, tail) do
    set
    |> get()
    |> structure(key, tail)
  end
end
