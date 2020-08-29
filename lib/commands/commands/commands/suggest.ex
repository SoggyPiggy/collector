defmodule Commands.Command.Suggest do
  @command %Commands.Command{
    id: :suggest,
    title: "Suggest",
    description: "Make any suggestion for the bot",
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

  defp confirm_recording({:ok, suggestion}, message) do
    """
    Suggestion has been recorded. `#{format_id(suggestion.id)}`
    **"**#{format_content(suggestion.content)}**"**
    """
    |> Discord.send(:reply, message)
  end

  defp format_id(id) do
    id
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
  end

  defp format_content(content) do
    content
    |> String.length()
    |> format_content(content)
  end
  defp format_content(length, content) when length > 255 do
    (
      content
      |> String.slice(0, 251)
    )
    <> "..."
  end
  defp format_content(_length, content), do: content
end
