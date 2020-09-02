defmodule Database.Seeds.FixMispellings20200902230620 do
  import Database

  def version(), do: 20200902230620

  def run() do
    "Spotted Blue Eye"
    |> get_coin_by_name()
    |> Ecto.Changeset.cast(%{file_dir: "gertrudes-rainbow"}, [:file_dir])
    |> Database.Repo.update!()

    "Burmese Dwarf Stickleback"
    |> get_coin_by_name()
    |> Ecto.Changeset.cast(%{file_dir: "paradoxus-toothpick"}, [:file_dir])
    |> Database.Repo.update!()

    "Scarlet Badis"
    |> get_coin_by_name()
    |> Ecto.Changeset.cast(%{file_dir: "scarlet-badis"}, [:file_dir])
    |> Database.Repo.update!()

    "Woodstock '69"
    |> get_coin_by_name()
    |> Ecto.Changeset.cast(%{file_dir: "woodstock"}, [:file_dir])
    |> Database.Repo.update!()
  end
end
