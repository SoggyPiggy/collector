defmodule Discord.Consumer do
  use Nostrum.Consumer

  @dialyzer {:nowarn_function, start_link: 0}

  def start_link(), do: Consumer.start_link(__MODULE__)

  def handle_event({:MESSAGE_CREATE, %{author: %{bot: nil}, content: content} = message, _ws}) do
    message
    |> is_message_valid()
    |> get_account_admin()
    |> pass_to_commands(content)
  end
  def handle_event(_), do: nil

  defp is_message_valid(_has_prefix = true, message), do: {:ok, message}
  defp is_message_valid(_has_prefix = false, _message), do: {:error, "Message is not a command"}
  defp is_message_valid(%{guild_id: nil} = message), do: {:ok, message}
  defp is_message_valid(message) do
    message.content
    |> String.starts_with?(">")
    |> is_message_valid(message)
  end

  defp get_account_admin({:error, _} = error), do: error
  defp get_account_admin({:ok, %{author: author} = message}) do
    author
    |> get_account()
    |> get_admin()
    |> Tuple.append(message)
  end

  defp get_account(author), do: {Database.get_account_by_discord_user(author)}
  defp get_admin({account}), do: {account, Database.has_admin_override(account)}

  defp pass_to_commands(data, input), do: Commands.execute(input, data)
end
