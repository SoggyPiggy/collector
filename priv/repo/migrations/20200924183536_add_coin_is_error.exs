defmodule Database.Repo.Migrations.AddCoinIsError do
  use Ecto.Migration

  def change do
    alter table(:coins) do
      add :is_error, :boolean, default: false
    end
  end
end
