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
    old_version = Database.get_seeding_version()
    Database.seed_data()
    new_version = Database.get_seeding_version()
    """
    Database Seed Data has been updated
    #{old_version} ==> #{new_version}
    """
    |> Discord.send(:reply, message)
  end
end
