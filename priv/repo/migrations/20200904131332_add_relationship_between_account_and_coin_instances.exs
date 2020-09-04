defmodule Database.Repo.Migrations.AddRelationshipBetweenAccountAndCoinInstances do
  use Ecto.Migration

  def change do
    alter table(:coin_instances) do
      add :account_id, references(:accounts)
    end
  end
end
