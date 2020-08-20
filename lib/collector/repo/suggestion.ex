defmodule Collector.Repo.Suggestion do
  alias Collector.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  schema "suggestions" do
    field :content, :string
    field :discord_username, :string

    belongs_to :account, Collector.Repo.Account

    timestamps([type: :utc_datetime, updated_at: false])
  end

  def create(account, params) do
    %Collector.Repo.Suggestion{}
    |> Repo.add_association(account)
    |> Changeset.cast(params, [:content, :discord_username])
    |> Changeset.validate_required([:content])
    |> Repo.insert()
  end
end
