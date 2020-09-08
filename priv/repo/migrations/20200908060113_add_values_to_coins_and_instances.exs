defmodule Database.Repo.Migrations.AddValuesToCoinsAndInstances do
  use Ecto.Migration

  def change do
    alter table(:coins) do
      add :value, :float
    end

    alter table(:coin_instances) do
      add :value, :float
      add :condition_roll, :float
      add :condition_natural, :float
      add :is_altered, :boolean
    end
  end
end
