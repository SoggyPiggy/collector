defmodule Database.Repo.Account do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "accounts" do
    field :discord_id, :integer

    has_one :account_settings, Database.Repo.AccountSettings
    has_many :coin_transactions, Database.Repo.CoinTransaction
    has_many :suggestions, Database.Repo.Suggestion

    timestamps([type: :utc_datetime])
  end

  def create(%{id: id}) do
    %Database.Repo.Account{}
    |> Changeset.cast(%{discord_id: id}, [:discord_id])
    |> Changeset.validate_required([:discord_id])
    |> Changeset.unique_constraint(:discord_id)
    |> Repo.insert()
  end

  def get_by_discord_user(%{id: id}), do: get_by_discord_id(id)
  def get_by_discord_id(id) do
    Database.Repo.Account
    |> Query.where(discord_id: ^id)
    |> Repo.one()
  end
end
