defmodule Commands do
  alias Commands.{Organiser, Processor}

  defdelegate execute(input, reply_data), to: Processor

  defdelegate find(command), to: Organiser
  defdelegate find(commands_list, command), to: Organiser
  defdelegate commands(), to: Organiser
  defdelegate commands_admin(), to: Organiser
  defdelegate commands_all(), to: Organiser
  defdelegate commands_registered(), to: Organiser
  defdelegate commands_unregistered(), to: Organiser
  defdelegate get_appropriate_commands(account), to: Organiser
end
