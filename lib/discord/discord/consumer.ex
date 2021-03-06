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
    |> Tuple.append(message)
  end

  defp get_account(author), do: {Database.Account.get(author)}

  defp pass_to_commands({:error, _reason} = error, _input), do: error
  defp pass_to_commands(data, input), do: Commands.execute(input, data)
end
