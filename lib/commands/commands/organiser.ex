defmodule Commands.Organiser do
  alias Commands.Command

  @commands [
    Command.Help,
    Command.Guide,
    Command.Registry,
    Command.Profile,
    Command.Collect,
    Command.Collection,
    Command.Sets,
    Command.ViewCoin,
    Command.Scrap,
    Command.Repair,
    Command.Suggest,
    Command.Changelog,
    Command.Seed,
    Command.Broadcast,
    Command.ToggleAdmin
  ]

  def commands_all(), do: @commands
  def commands_admin(),
    do: Enum.filter(@commands, fn command -> command.module().for_registered == true end)
  def commands(),
    do: Enum.filter(@commands, fn command -> command.module().is_public == true end)
  def commands_registered(),
    do: Enum.filter(commands(), fn command -> command.module().for_registered == true end)
  def commands_unregistered(),
    do: Enum.filter(commands(), fn command -> command.module().for_unregistered == true end)

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

  def get_appropriate_commands(nil), do: commands_unregistered()
  def get_appropriate_commands(true), do: commands_registered()
  def get_appropriate_commands(false), do: commands_unregistered()
  def get_appropriate_commands(%Database.Repo.Account{} = account) do
    account
    |> Database.AccountSettings.fetch(:admin)
    |> get_appropriate_commands(account)
  end
  def get_appropriate_commands(false, _account), do: commands_registered()
  def get_appropriate_commands(true, _account), do: commands_admin()
end
