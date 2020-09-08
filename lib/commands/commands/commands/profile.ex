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

  def execute("", {%Database.Repo.Account{discord_id: id} = account, message}) do
    account
    |> send_account("<@#{id}>", message)
  end

  def execute(args, {%Database.Repo.Account{discord_id: id}, message}) do
    args
    |> String.trim()
    |> String.replace(~r/<@!?|>/, "")
    |> String.to_integer()
    |> Database.Account.get()
    |> send_account("<@#{id}>", message)
  end

  defp send_account(nil, _content, _message), do: nil
  defp send_account(account, content, message), do: Discord.send(content, account, :reply, message)
end
