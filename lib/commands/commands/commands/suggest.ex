defmodule Commands.Command.Suggest do
  @command %Commands.Command{
    id: :suggest,
    title: "Suggest",
    description: "Make a suggestion for the bot",
    aliases: ["suggest", "suggestion"],
    examples: [">suggest There should be coins for pickles"]
  }

  def module(), do: @command

  def execute([content], {
    account,
    %{author: %{username: username, discriminator: discriminator}} = message
  }) do
    account
    |> Database.create_suggestion(%{
      content: content,
      discord_username: "#{username}##{discriminator}"
    })
    |> confirm_recording(message)
    end

    defp confirm_recording({:ok, _suggestion}, message) do
      "Suggestion has been recorded"
      |> DiscordReceiver.Speaker.send(:reply, message)
  end
end
