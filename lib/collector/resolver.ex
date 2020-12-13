defmodule Collector.AccountResolver do
  def resolve_account({:ok, item}), do: resolve_account(item)
  def resolve_account(%Database.Repo.Account{} = account, _reply_data), do: {:ok, account}
  def resolve_account(user, reply_data) do
    user
    |> check_database(Regex.match?(~r/<?@?!?\d+>?/, user))
    |> check_nostrum(reply_data)
    |> validate()
  end

  defp check_database(user, false), do: {:error, user}
  defp check_database(user, true) do
    user
    |> Database.Account.get()
    |> check_database_validate(user)
  end

  defp check_database_validate({:ok, item}, user), do: check_database_validate(item, user)
  defp check_database_validate(%Database.Repo.Account{} = account, _user), do: {:ok, account}
  defp check_database_validate(_, user), do: {:error, user}

  defp check_nostrum({:ok, _account} = ok, _reply_data), do: ok
  defp check_nostrum({:error, _user} = error, {_account, %Nostrum.Struct.Message{guild_id: nil}}), do: error
  defp check_nostrum({:error, user}, {_account, %Nostrum.Struct.Message{} = message}) do
    message.guild_id
    |> Nostrum.Api.list_guild_members(limit: 500)
    |> check_nostrum_fuzzy(user)
  end

  defp check_nostrum_fuzzy({:error, _reason}, user), do: {:error, user}
  defp check_nostrum_fuzzy({:ok, members}, user) do
    members
    |> Enum.filter(fn member -> member.user.bot == nil end)
    |> Enum.map(fn member ->
      jaro_nickname = jaro(member.nick, user)
      jaro_username = jaro(member.user.username, user)
      jaro_result = if jaro_nickname > jaro_username do jaro_nickname else jaro_username end
      {member.user.id, jaro_result}
    end)
    |> Enum.sort(fn {_id_a, jaro_a}, {_id_b, jaro_b} -> jaro_a > jaro_b end)
    |> check_nostrum_fuzzy_validate(user)
  end

  defp check_nostrum_fuzzy_validate([{id, _} | _], _user), do: {:ok, Database.Account.get(id)}
  defp check_nostrum_fuzzy_validate(_, user), do: {:error, user}

  defp validate({:ok, _account} = ok), do: ok
  defp validate({:error, _user}), do: {:error, "Account not found"}

  defp jaro(nil, _text), do: 0
  defp jaro(text1, text2), do: String.jaro_distance(text1, text2)
end
