defmodule Collector.Repo.Migrations.CreateGlobalSettings do
  use Ecto.Migration

  def change do
    create table(:global_settings) do
      add :key, :string
      add :string_value, :string
      add :integer_value, :integer
      add :float_value, :float
    end
  end
end
