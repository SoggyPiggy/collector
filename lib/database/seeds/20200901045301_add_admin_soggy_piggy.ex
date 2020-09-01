defmodule Database.Seeds.AddAdminSoggyPiggy20200901045301 do
  import Database

  def version(), do: 20200901045301

	def run() do
    id = "105094380452356096";

    create_account(%{id: id})

    soggy_piggy = get_account_by_discord_id(id)

    make_admin(soggy_piggy)
  end
end
