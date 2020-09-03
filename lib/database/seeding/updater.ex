defmodule Database.Seeding.Updater do
  def update() do
    get_modules()
    |> filter_seed_modules()
    |> remove_old_modules(Database.get_seeding_version())
    |> sort_modules()
    |> run_modules()
    |> update_database_version()
  end

  defp get_modules() do
    :collector
    |> :application.get_key(:modules)
    |> get_modules_verify_modules()
  end

  defp get_modules_verify_modules(:undefined), do: raise("Database.Seeding.Updater.get_modules() could not find modules")
  defp get_modules_verify_modules({:ok, modules}), do: modules

  defp filter_seed_modules(modules), do: Enum.filter(modules, fn module ->
    module
    |> Atom.to_string()
    |> String.starts_with?("Elixir.Database.Seeds")
  end)

  defp remove_old_modules(modules, current_version),
    do: Enum.filter(modules, fn module -> module.version() > current_version end)

  defp sort_modules(modules), do: Enum.sort(modules, fn module_a, module_b ->
    module_a.version() < module_b.version()
  end)

  defp run_modules([]), do: :no_change
  defp run_modules([module]) do
    module.run()

    {:ok, module.version()}
  end
  defp run_modules([module | tail]) do
    module.run()

    run_modules(tail)
  end

  defp update_database_version(:no_change), do: {:ok, Database.get_seeding_version()}
  defp update_database_version({:ok, version}), do: {:ok, Database.set_seeding_version(version)}

  defp get_seeding_version(), do: Database.get_global("seeding_version", :integer_value, 0)
  defp et_seeding_veriosn(version), do: Database.set_global("seeding_version", :integer_value, version)
end
