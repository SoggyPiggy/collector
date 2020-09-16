defmodule Discord.Speaker.CommandEmbed do
  alias Nostrum.Struct.Embed

  def build(command) do
    %Embed{}
    |> Embed.put_title("Help Menu: " <> command.title)
    |> Embed.put_description(
      [
        command.description,
        "\n**Aliases**\n`#{command.aliases |> Enum.join("`, `")}`",
        build_arguments(command),
        "\n**Examples**\n#{command.examples |> Enum.join("\n")}"
      ]
      |> List.flatten()
      |> Enum.filter(fn description_part -> description_part != "" end)
      |> Enum.join("\n")
    )
  end

  defp build_arguments(%Commands.Command{args_strict: []}), do: ""
  defp build_arguments(%Commands.Command{} = command) do
    command.args_strict
    |> Keyword.to_list()
    |> Enum.map(fn {key, _type} ->
      [
        "--" <> (
          key
          |> Atom.to_string()
          |> String.replace(~r/\_/, "-")
        ),
        command.args_aliases
        |> Keyword.to_list()
        |> Enum.filter(fn {_key_alias, key_target} -> key == key_target end)
        |> Enum.map(fn {key_alias, _key_target} -> "-" <> (key_alias |> Atom.to_string) end),
        command.args_descriptions
        |> Keyword.to_list()
        |> Enum.filter(fn {key_target, _description} -> key == key_target end)
        |> Enum.map(fn {_key_target, description} -> description end)
        |> description_argument_extract()
      ]
    end)
    |> Enum.map(fn [key, aliases, description] -> [
      "`#{[key | aliases] |> Enum.join("`, `")}`",
      " " <> description
    ] end)
    |> description_argument_title()
  end

  defp description_argument_extract([]), do: ""
  defp description_argument_extract([description]), do: description

  defp description_argument_title([]), do: []
  defp description_argument_title(args), do: ["\n**Arguments**", args]
end
