defmodule Database.Seeds.FixSuggestionDiscordNames20200925003945 do
  def version(), do: 20200925003945

  def run() do
    Database.Suggestion.all()
    |> Enum.filter(fn sug -> sug.discord_username == nil end)
    |> Enum.each(fn %Database.Repo.Suggestion{} = sug ->
      user =
        sug
        |> Database.Account.get()
        |> Map.get(:discord_id)
        |> Nostrum.Api.get_user!()

      sug
      |> Database.Suggestion.modify(%{discord_username: "#{user.username}##{user.discriminator}"})
      |> IO.inspect()
    end)
  end
end
