defmodule Database.Repo.GlobalSetting do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @values [:string_value, :integer_value, :float_value]

  schema "global_settings" do
    field :key, :string
    field :string_value, :string
    field :integer_value, :integer
    field :float_value, :float
  end

  def set_seeding_version(version), do: set("seeding_version", :string_value, version)
  def get_seeding_version(), do: get("seeding_version", :string_value, "0")

  defp set(key, type, value) do
    key
    |> get_setting(type, value)
    |> Changeset.cast(Map.put(%{}, type, value), @values)
    |> Repo.update()
  end

  defp get(key, type, default), do: get_setting(key, type, default) |> Map.fetch!(type)

  defp get_setting(key, type, default) do
    Database.Repo.GlobalSetting
    |> Query.where(key: ^key)
    |> Repo.one()
    |> case do
      nil -> create(key, type, default)
      setting -> setting
    end
  end

  defp create(key, type, value) do
    %Database.Repo.GlobalSetting{}
    |> Changeset.cast(Map.put(%{key: key}, type, value), [:key | @values])
    |> Changeset.validate_required([:key])
    |> Repo.insert!()
  end
end
