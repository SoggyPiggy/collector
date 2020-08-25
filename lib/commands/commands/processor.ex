defmodule Commands.Processor do
  def execute(input, {account, _is_admin, _reply_data} = data) do
    input
    |> process_down_split()
    |> process_command_arguments(account)
    |> execute_command(data)
  end

  defp execute_command({nil, _arguments}, _reply_data), do: {:error, "command not found"}
  defp execute_command({command, arguments}, {account, true, reply_data}),
    do: command.admin_execute(arguments, {account, reply_data})
  defp execute_command({command, arguments}, {account, false, reply_data}),
    do: command.execute(arguments, {account, reply_data})

  defp process_command_arguments([command | arguments], account) do
    {
      process_command(command, account),
      process_arguments(arguments)
    }
  end

  defp process_arguments(arguments), do: arguments

  defp process_command(command, %Database.Repo.Account{} = account),
    do: process_command(command, Database.has_admin_override(account))
  defp process_command(command, nil) do
    Commands.commands_unregistered()
    |> Commands.find(command)
  end
  defp process_command(command, true) do
    Commands.commands_admin()
    |> Commands.find(command)
  end
  defp process_command(command, false) do
    Commands.commands_registered()
    |> Commands.find(command)
  end

  defp process_down_split(input) do
    input
    |> String.downcase()
    |> String.replace(~r/^>/, "")
    |> OptionParser.split()
  end
end
