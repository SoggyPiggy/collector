defmodule Database.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :folder_dir, :string
    end
  end
end
