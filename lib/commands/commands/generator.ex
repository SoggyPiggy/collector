defmodule Commands.Generator do
  def new(name) do
    {
      process_name(name),
      get_path()
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
    |> Path.join("lib/commands/commands/commands")
  end

  defp ensure_path_exists({_name, path} = data) do
    unless File.dir?(path), do: File.mkdir!(path)

    data
  end

  defp generate_file({name, path}) do
    path
    |> Path.join("#{name}.ex")
    |> File.write!("""
    defmodule Commands.Command.#{name |> Macro.camelize()} do
      @command %Commands.Command{
        id: :#{name},
        title: "#{name |> Macro.camelize()}",
        description: "",
        aliases: ["#{name}"],
        examples: ["#{name}"]
      }

      def module(), do: @command

      def execute(_args, {_account, _message} = _reply_data) do
      end
    end
    """)
  end
end
