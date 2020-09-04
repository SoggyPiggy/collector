defmodule Commands.Command.ToggleAdmin do
  @command %Commands.Command{
    id: :toggle_admin,
    title: "Toggle Admin",
    description: "Toggles admin override for some commands",
    aliases: ["admin", "toggle-admin", "toggleadmin"],
    examples: [">toggle-admin"],
    is_public: false,
  }

  def module(), do: @command

  def execute(_args, {account, message}) do
    Database.AccountSettings.toggle(account, :admin_enabled)
    "Admin Override #{admin_status(account)}"
    |> Discord.send(:reply, message)
  end

  defp admin_status(true), do: "Enabled"
  defp admin_status(false), do: "Disabled"
  defp admin_status(account) do
    account
    |> Database.AccountSettings.all?([:admin, :admin_enabled])
    |> admin_status()
  end
end
