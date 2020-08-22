defmodule Database.Repo.Utils do
  def add_association(table, %{id: id} = associate) do
    table
    |> Map.put(
      associate
      |> Map.get(:__meta__)
      |> Map.get(:schema)
      |> Atom.to_string()
      |> String.replace(~r/.+\.(.+)/, "\\1_id")
      |> Macro.underscore()
      |> String.to_atom(),
      id
    )
    |> Map.put(
      associate
      |> Map.get(:__meta__)
      |> Map.get(:schema)
      |> Atom.to_string()
      |> String.replace(~r/.+\.(.+)/, "\\1")
      |> Macro.underscore()
      |> String.to_atom(),
      associate
    )
  end
end
