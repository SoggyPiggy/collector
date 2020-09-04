defmodule Database.Repo.AccountSettings do
  alias Database.Repo
  alias Ecto.{Query, Changeset}
  require Query
  use Ecto.Schema

  @modifiables [
    :admin,
    :admin_enabled,
    :discordia_is_invited_tech_demo
  ]

  schema "account_settings" do
    field :send_notifications, :boolean, default: true
    field :admin, :boolean, default: false
    field :admin_enabled, :boolean, default: false

    # Discordia
    field :discordia_is_invited_tech_demo, :boolean, default: false

    belongs_to :account, Database.Repo.Account
  end

  def new({:ok, item}), do: new(item)
  def new(%Database.Repo.Account{} = account) do
    %Database.Repo.AccountSettings{}
    |> Database.add_association(account)
    |> Changeset.unique_constraint(:account_id)
    |> Repo.insert()
  end
  def new(item) do
    item
    |> Database.Account.get()
    |> new()
  end

  def get({:ok, item}), do: get(item)
  def get(%Database.Repo.AccountSettings{} = settings), do: settings
  def get(%Database.Repo.Account{} = account) do
    account
    |> Database.preload(:account_settings)
    |> Map.get(:account_settings)
    |> case do
      nil -> new(account)
      settings -> settings
    end
  end
  def get(item) do
    item
    |> Database.Account.get()
    |> get()
  end

  def modify({:ok, item}, params), do: modify(item, params)
  def modify(settings, params) do
    settings
    |> get()
    |> Ecto.Changeset.cast(params, @modifiables)
    |> Database.Repo.update()
  end

  def fetch({:ok, item}, key), do: fetch(item, key)
  def fetch(settings, keys) when is_list(keys),
    do: Enum.map(keys, fn key -> fetch(settings, key) end)
  def fetch(%Database.Repo.AccountSettings{} = settings, key) when is_atom(key), do: Map.get(settings, key)
  def fetch(settings, key) do
    settings
    |> get()
    |> fetch(key)
  end

  def all?({:ok, item}, keys), do: all?(item, keys)
  def all?(settings, keys) when is_list(keys), do: fetch(settings, keys) |> Enum.all?()

  def any?({:ok, item}, keys), do: all?(item, keys)
  def any?(settings, keys) when is_list(keys), do: fetch(settings, keys) |> Enum.any?()

  def toggle(item, key, value \\ nil)
  def toggle({:ok, item}, key, value), do: toggle(item, key, value)
  def toggle(settings, key, value) when is_boolean(value), do: toggle(value, settings, key)
  def toggle(settings, key, nil) do
    settings
    |> get()
    |> Map.get(key)
    |> toggle(settings, key)
  end
  def toggle(value, settings, key) when is_boolean(value) do
    settings
    |> get()
    |> Changeset.cast(Map.put(%{}, key, !value), @modifiables)
    |> Database.Repo.update()
  end
end
