defmodule Collector.Repo.Category do
  alias Collector.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "categories" do
    field :name, :string
    field :folder_dir, :string, default: "_default"

    has_many :coins, Collector.Repo.Coin
  end

  def create(params) do
    %Collector.Repo.Category{}
    |> Changeset.cast(params, [:name, :folder_dir])
    |> Repo.insert()
  end

  def get_by_card(%{category_id: id}), do: get_by_id(id)

  def get_by_id(id), do: Repo.get!(Collector.Repo.Category, id)

  def get_by_name(name) do
    Collector.Repo.Category
    |> Query.where(:name, ^name)
    |> Repo.one()
  end
end
