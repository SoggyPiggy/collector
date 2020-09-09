defmodule Database.Repo.Utils do

  def add_association(table, %{id: id} = associate) do
    table
    |> Map.put(
      process_associate(associate, "\\1_id"),
      id
    )
    |> Map.put(
      process_associate(associate, "\\1"),
      associate
    )
  end

  def preload({:ok, table}, association), do: preload(table, association)
  def preload(table, association), do: Database.Repo.preload(table, association)

  defp process_associate(associate, replacement) do
    associate
    |> Map.get(:__meta__)
    |> Map.get(:schema)
    |> Atom.to_string()
    |> String.replace(~r/.+\.(.+)/, replacement)
    |> Macro.underscore()
    |> String.to_atom()
  end

  def friendly_coin_value(value) when is_float(value), do: "¤#{Float.round(value, 2)}"
  def friendly_coin_value(%Database.Repo.Coin{} = coin) do
    coin
    |> Database.Coin.fetch(:value)
    |> friendly_coin_value()
  end
  def friendly_coin_value(%Database.Repo.CoinInstance{} = coin) do
    coin
    |> Database.CoinInstance.fetch(:value)
    |> friendly_coin_value()
  end
end
