defmodule Database.Repo.Migrations.CreateCoinTransactions do
  use Ecto.Migration

  def change do
    create table(:coin_transactions) do
      add :account_id, references(:accounts)
      add :coin_instance_id, references(:coin_instances)
      add :amount, :integer, default: 1, required: true
      add :reason, :string
      timestamps([type: :utc_datetime, updated_at: false])
    end
  end
end
