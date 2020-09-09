defmodule Commands.Command.Profile do
  @command %Commands.Command{
    id: :user,
    title: "Profile",
    description: "Shows a user's profile card",
    aliases: ["p", "profile", "stats"],
    examples: [">p <@468616309521776659>"],
    is_public: false,
  }

  def module(), do: @command

  def execute("", {%Database.Repo.Account{} = account, message}) do
    account
    |> send_account(message)
  end

  def execute(args, {_account, message}) do
    args
    |> String.trim()
    |> String.replace(~r/<@!?|>/, "")
    |> String.to_integer()
    |> Database.Account.get()
    |> send_account(message)
  end

  defp send_account(nil, _message), do: nil
  defp send_account(account, message), do: Discord.send("", account, :reply, message)
end
