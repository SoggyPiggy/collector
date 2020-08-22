defmodule Database.Repo.Migrations.CreateSuggestions do
  use Ecto.Migration

  def change do
    create table(:suggestions) do
      add :content, :varchar
      add :discord_username, :string
      add :account_id, references(:accounts)
      timestamps([type: :utc_datetime, updated_at: false])
    end
  end
end
