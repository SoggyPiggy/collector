defmodule Commands.Command.Seed do
  @command %Commands.Command{
    id: :seed,
    title: "Seed Data",
    description: "Seed the database with the lastest data",
    aliases: ["seed"],
    examples: [">seed"],
    is_public: false,
  }

  def module(), do: @command

  def execute(_args, {_account, message}) do
    old_version = Database.get_global("seeding_version", :integer_value, 0)
    {:ok, new_version} = Database.update_seeds()
    """
    Database Seed Data has been updated
    #{old_version} ==> #{new_version}
    """
    |> Discord.send(:reply, message)
  end
end
