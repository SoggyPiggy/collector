defmodule Database.Repo.Migrations.AddValuesToCoinsAndInstances do
  use Ecto.Migration

  def change do
    alter table(:coins) do
      add :value, :float
    end

    alter table(:coin_instances) do
      add :value, :float
    end
  end
end
