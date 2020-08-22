defmodule Commands.Command.Suggest do
  @command %Commands.Command{
    id: :suggest,
    title: "Suggest",
    description: "Make a suggestion for the bot",
    aliases: ["suggest", "suggestion"],
    examples: [">suggest There should be coins for pickles"]
  }

  def module(), do: @command

  def execute(suggestion, {
    account,
    %{author: %{username: username, discriminator: discriminator}} = message
  }) do
    account
    |> Database.create_suggestion(%{
      content: suggestion |> Enum.join(" "),
      discord_username: "#{username}##{discriminator}"
    })
    |> confirm_recording(message)
  end

  defp confirm_recording({:ok, _suggestion}, message) do
    "Suggestion has been recorded"
    |> Discord.send(:reply, message)
  end
end
