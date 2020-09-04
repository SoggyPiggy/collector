defmodule Database.Repo.Account do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "accounts" do
    field :discord_id, :integer

    has_one :account_settings, Database.Repo.AccountSettings
    has_many :coin_instances, Database.Repo.CoinInstance
    has_many :coin_transactions, Database.Repo.CoinTransaction
    has_many :suggestions, Database.Repo.Suggestion

    timestamps([type: :utc_datetime])
  end

  def new(%Nostrum.Struct.User{id: id}), do: new(id)
  def new(id) when is_integer(id) do
    %Database.Repo.Account{}
    |> Changeset.cast(%{discord_id: id}, [:discord_id])
    |> Changeset.validate_required([:discord_id])
    |> Changeset.unique_constraint(:discord_id)
    |> Repo.insert()
  end

  def get({:ok, item}), do: get(item)
  def get(%Nostrum.Struct.Message{author: %{id: id}}), do: get(id)
  def get(%Nostrum.Struct.User{id: id}), do: get(id)
  def get(%Database.Repo.Account{} = account), do: account
  def get(%Database.Repo.CoinInstance{} = coin_instance) do
    coin_instance
    |> Database.preload(:account)
    |> Map.get(:account)
  end
  def get(%Database.Repo.CoinTransaction{} = coin_transaction) do
    coin_transaction
    |> Database.preload(:account)
    |> Map.get(:account)
  end
  def get(%Database.Repo.Suggestion{} = suggestion) do
    suggestion
    |> Database.preload(:account)
    |> Map.get(:account)
  end
  def get(id) when is_integer(id) do
    Database.Repo.Account
    |> Query.where(discord_id: ^id)
    |> Repo.one()
  end
end
