defmodule Database.Repo.Migrations.CreateSets do
  use Ecto.Migration

  def change do
    create table(:sets) do
      add :name, :string
      add :folder_dir, :string
      add :set_id, references(:sets)
    end
  end
end
