defmodule Commands.Command.Guide do
  @command %Commands.Command{
    id: :guide,
    title: "Guide",
    description: "Useful information about the bot",
    aliases: ["guide"],
    examples: ["guide"],
    is_public: false
  }

  def module(), do: @command

  def execute(_args, reply_data) do
    {:ok,
      [
        {"Coin Grades", """
        Coin grades are the titles given to an instance of a coin based off of its condition.
        The following are the possbile coin grades in order of best to worst

        Mint+
        Mint
        Good+
        Good
        Good-
        Average+
        Average
        Average-
        Bad+
        Bad
        Bad-
        Terrible
        """}
      ]
    }
    |> send_reply(reply_data)
  end

  # defp send_reply({:error, reason}, {%{discord_id: id}, message}),
  #   do: Discord.send("<@#{id}>, #{reason}", :reply, message)

  defp send_reply({:ok, [{title, content}]}, {_account, message}),
    do: Discord.send("**#{title}**\n#{content}", :reply, message)
end
