defmodule Database.Repo.Utils do

  @dialyzer {:nowarn_function, get_latest_version: 2}

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

  def seed_data() do
    path = Path.join(File.cwd!, "priv/repo/seeds")
    unless File.dir?(path), do: File.mkdir_p!(path)
    version = Database.get_seeding_version()
    File.ls!(path)
    |> Enum.sort()
    |> Enum.map(fn file -> {file, String.split(file, "_", parts: 2) |> List.first()} end)
    |> Enum.filter(fn {_file, file_version} -> Version.compare("#{version}.0.0", "#{file_version}.0.0") == :lt end)
    |> seed_data_run_files(path)
    |> seed_data_get_latest_version(version)
    |> Database.set_seeding_version()

    :ok
  end

  defp seed_data_run_files([], _dir), do: []
  defp seed_data_run_files([{file, _} | tail] = data, dir) do
    Code.compile_file(Path.join(dir, file))
    seed_data_run_files(tail, dir)
    data
  end

  defp seed_data_get_latest_version([], version), do: version
  defp seed_data_get_latest_version([{_, version} | []], _), do: version
  defp seed_data_get_latest_version([_ | [_ | _] = tail], version), do: seed_data_get_latest_version(tail, version)

  def seed_gen(name) do
    path = Path.join(File.cwd!, "priv/repo/seeds")
    unless File.dir?(path), do: File.mkdir!(path)
    time = seed_gen_timestamp()
    file_suffix = "#{name |> String.replace(" ", "_") |> Macro.underscore()}.exs"
    file = Path.join(path, "#{time}_#{file_suffix}")
    File.write!(file, "import Database\n\n")
  end

  defp seed_gen_pad(n), do: String.pad_leading("#{n}", 2, "0")

  defp seed_gen_timestamp() do
    {{year, month, day}, {hour, minute, second}} = :calendar.universal_time()
    "#{year}#{seed_gen_pad(month)}#{seed_gen_pad(day)}#{seed_gen_pad(hour)}#{seed_gen_pad(minute)}#{seed_gen_pad(second)}"
  end
end
