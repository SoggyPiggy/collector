defmodule Database.Repo.Migrations.ChangeGlobalSettingIntToBigint do
  use Ecto.Migration

  def change do
    alter table(:global_settings) do
      modify :integer_value, :bigint, from: :integer
    end
  end
end
