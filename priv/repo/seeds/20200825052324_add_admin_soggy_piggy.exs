import Database

id = "105094380452356096"

%{id: id}
|> Database.create_account()

soggy_piggy = Database.get_account_by_discord_id(id)

soggy_piggy
|> Database.make_admin()
