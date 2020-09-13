defmodule Discord.Speaker.ChangeLogEmbed do
  alias Nostrum.Struct.Embed

  def build(%{version: version} = change_log) do
    %Embed{}
    |> Embed.put_title(change_log.name)
    |> put_patches(version, change_log.patches)
  end

  defp put_patches(embed, _version, []), do: embed
  defp put_patches(embed, version, [patch]),
    do: Embed.put_field(embed, "**`#{version}.#{patch.version}`**", get_notes(patch))
  defp put_patches(embed, version, [patch | tail]) do
    embed
    |> Embed.put_field("**`#{version}.#{patch.version}`**", get_notes(patch))
    |> put_patches(version, tail)
  end

  defp get_notes(patch) do
    patch.notes
    |> Enum.map(fn {title, notes} -> (
      "**#{title}**"
      ) <> (
        notes
        |> Enum.map(fn note -> "- #{note}" end)
        |> Enum.join("\n")
      )
    end)
    |> Enum.join("\n")
  end
end
