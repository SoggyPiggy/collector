defmodule Commands.Organiser do
  alias Commands.Command

  @commands [
    Command.Help,
    Command.Registry,
    Command.Collect,
    Command.Suggest,
    Command.Changelog
  ]

  def commands_all(), do: @commands
  def commands_admin(), do: @commands
  def commands() do
    @commands
    |> Enum.filter(fn command ->
      command.module().active == true &&
      command.module().for_admin_only == false
    end)
  end
  def commands_registered() do
    commands()
    |> Enum.filter(fn command -> command.module().for_registered == true end)
  end
  def commands_unregistered() do
    commands()
    |> Enum.filter(fn command -> command.module().for_unregistered == true end)
  end

  def find(command), do: find(commands_all(), command)
  def find(commands, command_aliases) when is_list(command_aliases) do
    command_aliases
    |> Enum.map(fn command_alias -> find(commands, command_alias) end)
    |> Enum.filter(fn command -> command != nil end)
  end
  def find(commands, command_id) when is_atom(command_id) do
    commands
    |> Enum.find(nil, fn command -> command.module().id == command_id end)
  end
  def find(commands, command_alias) when is_bitstring(command_alias) do
    commands
    |> Enum.find(nil, fn command ->
      command.module()
      |> Map.get(:aliases)
      |> Enum.any?(fn command_module_alias -> command_module_alias == command_alias end)
    end)
  end
end
