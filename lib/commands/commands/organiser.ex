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
  def commands(nil), do: commands(false)
  def commands(true) do
    commands()
    |> Enum.filter(fn command -> command.module().for_registered == true end)
  end
  def commands(false) do
    commands()
    |> Enum.filter(fn command -> command.module().for_unregistered == true end)
  end

  def get(id, is_registered \\ nil), do: resolve(id, is_registered)

  defp resolve(ids, is_registered) when is_list(ids), do: Enum.map(ids, fn id -> resolve(id, is_registered) end)
  defp resolve(id, is_registered) when is_atom(id) do
    is_registered
    |> commands()
    |> Enum.find(:error, fn command ->
      command.module().id == id
    end)
  end
  defp resolve(id, is_registered) when is_bitstring(id) do
    is_registered
    |> commands()
    |> Enum.find(:error, fn command ->
      command.module().aliases
      |> Enum.find(fn command_alias ->
        String.downcase(id) == String.downcase(command_alias)
      end) != nil
    end)
  end
end
