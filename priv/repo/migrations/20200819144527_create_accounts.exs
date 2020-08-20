defmodule Collector.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :discord_id, :bigint
      timestamps([type: :utc_datetime])
    end

    create unique_index(:accounts, [:discord_id])
  end
  end
end
