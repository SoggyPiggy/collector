defmodule Commands.Command.Set do
  @command %Commands.Command{
    id: :set,
    title: "Set",
    description: "",
    aliases: ["set"],
    examples: ["set"],
    is_public: false,
  }

  def module(), do: @command

  def execute(args, {_account, _message} = reply_data) do
    args
    |> OptionParser.split()
    |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    |> check_params()
    |> check_set()
    # |> check_private
    |> send_reply(reply_data)
  end

  defp check_params({_params, [], _error}), do: {:error, "Set not provided"}
  defp check_params({_params, [_ | [_ | _]], _error}), do: {:error, "Too many set references provided"}
  defp check_params({_params, [set], _error}), do: {:ok, set}

  defp check_set({:error, _reason} = error), do: error
  defp check_set({:ok, set}) do
    set
    |> Database.Set.get()
    |> check_set_validate()
  end

  defp check_set_validate(%Database.Repo.Set{} = set), do: {:ok, set}
  defp check_set_validate(_), do: {:error, "Improper set reference provided"}

  defp send_reply({:error, reason}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  defp send_reply({:ok, set}, {%{discord_id: id}, message}),
    do: Discord.send("<@#{id}>", set, :reply, message)
end
