defmodule Commands.Command.Broadcast do
  @command %Commands.Command{
    id: :broadcast,
    title: "Broadcast",
    description: "Broadcasts a message to a specific channel",
    aliases: ["echo", "broadcast"],
    examples: [">echo --channel 736021368981946409 --message \"This is one big ol example\""],
    is_public: false,
    args_strict: [{:channel, :integer}, {:message, :string}],
    args_aliases: [c: :channel, m: :message]
  }

  def module(), do: @command

  def execute(args, _) do
    args
    |> OptionParser.split()
    |> OptionParser.parse([strict: @command.args_strict, aliases: @command.args_aliases])
    |> broadcast()
  end

  defp broadcast({[], _message, _}), do: nil
  defp broadcast({args, _split_sentence, _}) do
    Discord.send(args[:message], args[:channel])
  end
end
