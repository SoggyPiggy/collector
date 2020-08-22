defmodule Database.Repo.Category do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "categories" do
    field :name, :string
    field :folder_dir, :string, default: "_default"

    has_many :coins, Database.Repo.Coin
  end

  def create(params) do
    %Database.Repo.Category{}
    |> Changeset.cast(params, [:name, :folder_dir])
    |> Repo.insert()
  end

  def get_by_card(%{category_id: id}), do: get_by_id(id)

  def get_by_id(id), do: Repo.get!(Database.Repo.Category, id)

  def get_by_name(name) do
    Database.Repo.Category
    |> Query.where(:name, ^name)
    |> Repo.one()
  end
end
