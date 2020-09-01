defmodule Database.Seeding.Generator do
  def new(name) do
    {
      process_name(name),
      get_path(),
      get_timestamp()
    }
    |> ensure_path_exists()
    |> generate_file()
  end

  defp process_name(name) do
    name
    |> String.replace(" ", "_")
    |> Macro.underscore()
  end

  defp get_path() do
    File.cwd!()
    |> Path.join("lib/database/seeds")
  end

  defp get_timestamp() do
    :calendar.universal_time()
    |> get_timestamp()
  end
  defp get_timestamp({{year, month, day}, {hour, minute, second}}) do
    {
      year,
      String.pad_leading("#{month}", 2, "0"),
      String.pad_leading("#{day}", 2, "0"),
      String.pad_leading("#{hour}", 2, "0"),
      String.pad_leading("#{minute}", 2, "0"),
      String.pad_leading("#{second}", 2, "0")
    }
    |> get_timestamp()
  end
  defp get_timestamp({year, month, day, hour, minute, second}),
    do: "#{year}#{month}#{day}#{hour}#{minute}#{second}"

  defp ensure_path_exists({_name, path, _timestamp} = data) do
    unless File.dir?(path), do: File.mkdir!(path)

    data
  end

  defp generate_file({name, path, timestamp}) do
    path
    |> Path.join("#{timestamp}_#{name}.ex")
    |> File.write!("""
    defmodule Database.Seeds.#{name |> Macro.camelize()}#{timestamp} do
      import Database\n
      def version(), do: #{timestamp}\n
    	def run() do
      \t
      end
    end
    """)
  end
end
