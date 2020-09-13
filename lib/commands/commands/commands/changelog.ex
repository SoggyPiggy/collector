defmodule Commands.Command.Changelog do
  @command %Commands.Command{
    id: :patch_notes,
    title: "Patch Notes",
    description: "Check out the latest patch notes to find out whats new",
    aliases: ["patch", "patchnotes", "patch-notes", "whatsnew", "changelog"],
    examples: [">whatsnew"],
    args_strict: [{:previous, :integer}, {:list, :boolean}],
    args_aliases: [prev: :previous, l: :list]
  }

  def module(), do: @command

  def execute(args, reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_arguments()
    |> get_embeddable()
    |> send_reply(reply_data)
  end

  defp check_arguments({params, _, _errors}) do
    {
      Keyword.get(params, :list, false),
      Keyword.get(params, :previous, 0)
    }
    |> check_arguments_verify()
  end

  defp check_arguments_verify({true, _previous}), do: {:ok, "list"}
  defp check_arguments_verify({false, previous}), do: {:ok, previous}

  defp get_embeddable({:ok, "list"}), do: {:ok, Changelog.list()}
  defp get_embeddable({:ok, previous}), do: {:ok, Changelog.get_previous(previous)}

  defp send_reply({:ok, embedible}, {_account, message}),
    do: Discord.send("", embedible, :reply, message)
end
