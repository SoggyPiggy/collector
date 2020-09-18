defmodule Commands.Command.AdminSearch do
  @command %Commands.Command{
    id: :admin_search,
    title: "Broadcast",
    description: "Search through database tables",
    aliases: ["as", "admin-search", "adminsearch"],
    examples: ["as -t coins -u <@468616309521776659>"],
    is_public: false,
    args_strict: [table: :string, user: :string, id: :string],
    args_aliases: [t: :table, u: :user]
  }

  def module(), do: @command

  def execute(_args, _reply_data), do: nil
end
