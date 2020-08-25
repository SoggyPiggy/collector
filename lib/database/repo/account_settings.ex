defmodule Database.Repo.AccountSettings do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "account_settings" do
    field :send_notifications, :boolean, default: true
    field :admin, :boolean, default: false
    field :admin_enabled, :boolean, default: false

    belongs_to :account, Database.Repo.Account
  end

  def get(%Database.Repo.Account{id: id} = account) do
    Database.Repo.AccountSettings
    |> Query.where(account_id: ^id)
    |> Repo.one()
    |> case do
      nil -> create!(account)
      settings -> settings
    end
  end

  def create!(account) do
    {:ok, account_settings} = create(account)
    account_settings
  end
  def create(account, params \\ {})
  def create({:ok, account}, params), do: create(account, params)
  def create(account, params) do
    %Database.Repo.AccountSettings{}
    |> Database.add_association(account)
    |> Changeset.cast(params, [])
    |> Changeset.unique_constraint(:account_id)
    |> Repo.insert()
  end

  def is_admin(nil), do: false
  def is_admin(settings) do
    settings
    |> ensure_settings()
    |> Map.get(:admin, false)
  end

  def has_admin_override(nil), do: false
  def has_admin_override(%Database.Repo.Account{} = account) do
    account
    |> Database.get_account_settings()
    |> has_admin_override()
  end
  def has_admin_override(%Database.Repo.AccountSettings{admin: admin, admin_enabled: is_enabled}),
    do: admin && is_enabled

  def make_admin(nil), do: {:error, "can not create admin from nil"}
  def make_admin(settings) do
    settings
    |> ensure_settings()
    |> Changeset.cast(%{admin: true}, [:admin])
    |> Repo.update()
  end


  def toggle_admin({current, settings}) do
    settings
    |> ensure_settings()
    |> Map.put(:admin_enabled, current)
    |> Changeset.cast(%{admin_enabled: !current}, [:admin_enabled])
    |> Repo.update()
  end
  def toggle_admin(settings) do
    settings
    |> ensure_settings()
    |> Map.pop(:admin_enabled)
    |> toggle_admin()
  end

  defp ensure_settings(%Database.Repo.AccountSettings{} = settings), do: settings
  defp ensure_settings(%Database.Repo.Account{} = account), do: Database.get_account_settings(account)
end
