defmodule Collector.Repo.Account do
  alias Collector.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "accounts" do
    field :discord_id, :integer

    has_one :account_settings, Collector.Repo.AccountSettings
    has_many :coin_transactions, Collector.Repo.CoinTransaction
    has_many :suggestions, Collector.Repo.Suggestion

    timestamps([type: :utc_datetime])
  end

  def create(%{id: id}) do
    %Collector.Repo.Account{}
    |> Changeset.cast(%{discord_id: id}, [:discord_id])
    |> Changeset.validate_required([:discord_id])
    |> Changeset.unique_constraint(:discord_id)
    |> Repo.insert()
  end

  def get_by_discord_user(%{id: id}), do: get_by_discord_id(id)
  def get_by_discord_id(id) do
    Collector.Repo.Account
    |> Query.where(discord_id: ^id)
    |> Repo.one()
  end
end
