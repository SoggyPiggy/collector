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

  def create({:ok, account}, params), do: create(account, params)
  def create(account, params) do
    %Database.Repo.Suggestion{}
    |> Database.add_association(account)
    |> Changeset.cast(params, [:content, :discord_username])
    |> Changeset.validate_required([:content])
    |> Repo.insert()
  end
end
