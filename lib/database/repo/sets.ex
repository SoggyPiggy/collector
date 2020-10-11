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
  def get(reference) when is_bitstring(reference) do
    reference
    |> String.to_integer(36)
    |> get()
  end
  def get(params) when is_list(params) do
    Database.Repo.Set
    |> Query.where(^params)
    |> Repo.one()
  end
  def get(item) do
    item
    |> Database.Coin.get()
    |> get()
  end

  def all() do
    Database.Repo.Set
    |> Database.Repo.all()
  end
  def all({:ok, item}), do: all(item)
  def all(params) when is_list(params) do
    Database.Repo.Set
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

  def reference({:ok, item}), do: reference(item)
  def reference(set) do
    set
    |> get()
    |> Map.get(:id)
    |> Integer.to_string(36)
    |> String.pad_leading(2, "0")
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

  def has_coin(%Database.Repo.Set{} = set) do
    Database.Repo.Coin
    |> Ecto.Query.where([set_id: ^set.id])
    |> Ecto.Query.first()
    |> Database.Repo.one()
    |> (fn coin -> coin != nil end).()
  end
  def has_coin(set) do
    set
    |> get()
    |> has_coin()
  end
end
