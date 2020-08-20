defmodule Collector.Repo.AccountSettings do
  alias Collector.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "account_settings" do
    field :send_notifications, :boolean, default: true
    field :admin, :boolean, default: false
    field :admin_enabled, :boolean, default: false

    belongs_to :account, Collector.Repo.Account
  end

  def get(%Collector.Repo.Account{id: id} = account) do
    Collector.Repo.AccountSettings
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
    %Collector.Repo.AccountSettings{}
    |> Repo.add_association(account)
    |> Changeset.cast(params, [])
    |> Changeset.unique_constraint(:account_id)
    |> Repo.insert()
  end

  def has_admin_override(%{admin: admin, admin_enabled: admin_enabled}),
    do: admin && admin_enabled
end
