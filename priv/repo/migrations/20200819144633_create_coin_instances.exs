defmodule Collector.Repo.Migrations.CreateCoinInstances do
  use Ecto.Migration

  def change do
    create table(:coin_instances) do
      add :coin_id, references(:coins)
      add :condition, :float
      timestamps([type: :utc_datetime])
    end
  end
end
