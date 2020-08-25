defmodule Database.Repo.Set do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "sets" do
    field :name, :string
    field :folder_dir, :string, default: "_default"

    belongs_to :set, Database.Repo.Set
    has_many :sets, Database.Repo.Set
    has_many :coins, Database.Repo.Coin
  end

  def create(set, params) do
    %Database.Repo.Set{}
    |> Database.add_association(set)
    |> create_changeset_insert(params)
  end

  def create(params) do
    %Database.Repo.Set{}
    |> create_changeset_insert(params)
  end

  def create_changeset_insert(set, params) do
    set
    |> Changeset.cast(params, [:name, :folder_dir])
    |> Repo.insert()
  end

  def get_by_card(%{set_id: id}), do: get_by_id(id)

  def get_by_id(id), do: Repo.get!(Database.Repo.Set, id)

  def get_by_name(name) do
    Database.Repo.Set
    |> Query.where(:name, ^name)
    |> Repo.one()
  end
end
