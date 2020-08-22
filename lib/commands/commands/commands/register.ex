defmodule Commands.Command.Registry do
  @command %Commands.Command{
    id: :register,
    title: "Register",
    description: "Registers the user an account",
    aliases: ["register"],
    examples: ["register"],
    for_registered: false,
    for_unregistered: true,
  }

  def module(), do: @command

  def execute(_args, {nil, %{author: user}}) do
    user
    |> Database.create_account()
    |> validate_and_notify(user)
  end
  def execute(_args, _data), do: nil

  defp validate_and_notify({:ok, _account}, %{id: id} = user) do
    """
    <@#{id}> is now registered with this bot.
    The `help` command will now display commands more relevant to you.
    You will now start to collect coins while using discord. You may also collect one coin a day using the `collect` command. *Reset happens at 8pm EST*
    """
    |> Discord.send(:notify, user)
  end
end
