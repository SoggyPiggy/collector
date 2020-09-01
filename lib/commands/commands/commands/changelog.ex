defmodule Commands.Command.Changelog do
  @command %Commands.Command{
    id: :patch_notes,
    title: "Patch Notes",
    description: "Check out the latest patch notes to find out whats new",
    aliases: ["patchnotes", "patch", "patch-notes", "whatsnew", "changelog", "pn", "cl"],
    examples: [">whatsnew"]
  }

  def module(), do: @command

  def execute(_args, data) do
    Changelog.get_latest()
    |> parse_log()
    |> List.flatten()
    |> Enum.join("\n")
    |> send_message(data)
  end

  defp send_message(content, {account, message}) do
    account
    |> Database.get_account_settings()
    |> Database.has_admin_override()
    |> direct_send(content, message)
  end
  defp direct_send(true, content, message), do: Discord.send(content, :reply, message)
  defp direct_send(false, content, message), do: Discord.send(content, :direct, message)

  defp parse_log(%{name: name, version: version, patches: patches}),
    do: ["__**#{name}**__" | parse_patches(patches, version)]

  defp parse_patches([], _version), do: []
  defp parse_patches([patch], version), do: [parse_patch(patch, version)]
  defp parse_patches([patch | tail], version), do: [parse_patch(patch, version) | parse_patches(tail, version)]

  defp parse_patch(%{version: patch_version, notes: sections}, version),
    do: ["`#{version}.#{patch_version}`" | parse_sections(sections)]

  defp parse_sections([]), do: []
  defp parse_sections([{_title, []}]), do: []
  defp parse_sections([{_title, []} | tail]), do: [parse_sections(tail)]
  defp parse_sections([{title, notes}]), do: ["**#{title}**" | [parse_notes(notes)]]
  defp parse_sections([{title, notes} | tail]), do: ["**#{title}**" | [parse_notes(notes) | [parse_sections(tail)]]]

  defp parse_notes([]), do: []
  defp parse_notes([note]), do: ["- #{note}"]
  defp parse_notes([note | tail]), do: ["- #{note}" | parse_notes(tail)]
end
