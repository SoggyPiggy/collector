defmodule Database.Seeds.AddAdminSoggyPiggy20200901045301 do
  alias Database.{Account, AccountSettings}

  def version(), do: 20200901045301

	def run() do
    id = 105094380452356096;

    Account.new(id)

    Account.get(id)
    |> AccountSettings.get()
    |> AccountSettings.toggle([:admin, :admin_enabled], true)
  end
end
