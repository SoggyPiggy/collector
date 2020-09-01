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

  defp process_associate(associate, replacement) do
    associate
    |> Map.get(:__meta__)
    |> Map.get(:schema)
    |> Atom.to_string()
    |> String.replace(~r/.+\.(.+)/, replacement)
    |> Macro.underscore()
    |> String.to_atom()
  end
end
