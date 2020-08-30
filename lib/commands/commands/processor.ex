defmodule Commands.Processor do
  def execute(input, {account, _reply_data} = data) do
    input
    |> String.split(" ", parts: 2)
    |> process_command_arguments(account)
    |> execute_command(data)
  end

  defp execute_command({nil, _arguments}, _reply_data), do: {:error, "command not found"}
  defp execute_command({command, arguments}, {account, reply_data}),
    do: command.execute(arguments, {account, reply_data})

  defp process_command_arguments([command | arguments], account) do
    {
      command
      |> String.downcase()
      |> process_command(account),
      process_arguments(arguments)
    }
  end

  defp process_arguments([]), do: ""
  defp process_arguments([arguments]), do: arguments

  defp process_command(command, account) do
    account
    |> Commands.get_appropriate_commands()
    |> Commands.find(command)
  end
end
