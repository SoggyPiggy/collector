defmodule Database.Repo.Migrations.ModifyAccountSettingsAddDiscordiaTechDemo do
  use Ecto.Migration

  def change do
    alter table(:account_settings) do
      add :discordia_is_invited_tech_demo, :boolean, default: false
    end
  end
end
