defmodule Database.Repo.Suggestion do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "suggestions" do
    field :content, :string
    field :discord_username, :string

    belongs_to :account, Database.Repo.Account

    timestamps([type: :utc_datetime, updated_at: false])
  end

  def new(item, name, content), do: new(item, %{name: name, content: content})
  def new({:ok, item}, params), do: new(item, params)
  def new(account, params) do
    %Database.Repo.Suggestion{}
    |> Database.add_association(account)
    |> Changeset.cast(params, [:content, :discord_username])
    |> Changeset.validate_required([:content])
    |> Repo.insert()
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.Suggestion{} = suggestion), do: suggestion
  def get(%Database.Repo.Account{} = account) do
    account
    |> Database.preload(:suggestions)
    |> Map.get(:suggestions)
  end
  def get(id) when is_integer(id) do
    Database.Repo.Suggestion
    |> Database.Repo.get(id)
  end
  def get(id) when is_bitstring(id) do
    id
    |> String.to_integer(36)
    |> get()
  end

  def referance(suggestion) do
    suggestion
    |> get()
    |> Map.get(:id)
    |> Integer.to_string(36)
    |> String.pad_leading(2, "0")
  end

  # TODO: needs more touching up
  def last(item, limit \\ 1)
  def last({:ok, item}, limit), do: last(item, limit)
  def last(%Database.Repo.Account{} = account, limit) do
    Database.Repo.CoinTransaction
    |> Query.where([account_id: ^account.id])
    |> Query.limit(^limit)
    |> Query.order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
