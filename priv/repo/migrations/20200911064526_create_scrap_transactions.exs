defmodule Database.Repo.Migrations.CreateScrapTransactions do
  use Ecto.Migration

  def change do
    create table(:scrap_transactions) do
      add :account_id, references(:accounts)
      add :coin_instance_id, references(:coin_instances)
      add :amount, :integer, required: true
      add :reason, :string
      timestamps([type: :utc_datetime, updated_at: false])
    end
  end
end
