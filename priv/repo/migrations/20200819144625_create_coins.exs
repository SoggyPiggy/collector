defmodule Database.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :name, :string
      add :file_dir, :string
      add :categories_id, references(:categories)
      add :in_circulation, :boolean
      add :weight, :integer
    end
  end
end
