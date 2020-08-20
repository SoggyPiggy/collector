defmodule Collector.Repo.Migrations.CreateAccontSettings do
  use Ecto.Migration

  def change do
    create table(:account_settings) do
      add :account_id, references(:accounts)
      add :send_notifications, :boolean, default: true
      add :admin, :boolean, default: false
      add :admin_enabled, :boolean, default: false
    end

    create unique_index(:account_settings, [:account_id])
  end
end
