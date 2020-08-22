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
  def create(account, params \\ %{}) do
    %Database.Repo.AccountSettings{}
    |> Repo.add_association(account)
    |> Changeset.cast(params, [])
    |> Changeset.unique_constraint(:account_id)
    |> Repo.insert()
  end

  def has_admin_override(nil), do: false
  def has_admin_override(%{admin: admin, admin_enabled: is_enabled}), do: admin && is_enabled
end
