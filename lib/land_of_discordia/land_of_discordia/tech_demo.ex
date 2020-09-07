defmodule LandOfDiscordia.TechDemo do
  use GenServer

  def start_link(_), do: start_link()
  def start_link(), do: GenServer.start_link(__MODULE__, {})

  def check_and_invite({:ok, item}), do: check_and_invite(item)
  def check_and_invite(%Database.Repo.Account{} = account) do
    {:ok, pid} = start_link()
    GenServer.cast(pid, {:check_and_invite, account})
  end

  def get_and_send({:error, _reason}), do: {:noreply, {}}
  def get_and_send({:ok, item}), do: get_and_send(item)
  def get_and_send(account) do
    {:ok, pid} = start_link()
    GenServer.cast(pid, {:send_invite, account})
  end

  def init(stack), do: {:ok, stack}

  def handle_cast({:check_and_invite, account}, _state) do
    account
    |> check_global()
    |> check_account()
    |> check_roll()
    |> update()
    |> get_and_send()

    {:noreply, {}}
  end

  def handle_cast({:send_invite, %{discord_id: id}}, _state) do
    id
    |> LandOfDiscordia.Api.get_tech_key()
    |> send_invite(id)
  end

  defp check_global(account) do
    get_discordia_tech_demo_last_invite()
    |> Date.from_iso8601!()
    |> Date.compare(Date.utc_today())
    |> check_global_verify(account)
  end

  defp check_global_verify(:lt, account), do: {:ok, account}
  defp check_global_verify(_result, _account), do: {:error, "Invite already sent today"}

  defp check_account({:error, _reason} = error), do: error
  defp check_account({:ok, account}) do
    account
    |> Database.AccountSettings.get()
    |> Map.get(:discordia_is_invited_tech_demo)
    |> check_account_verify(account)
  end

  defp check_account_verify(true, _account), do: {:error, "Account already invited"}
  defp check_account_verify(false, account), do: {:ok, account}

  defp check_roll({:error, _reason} = error), do: error
  defp check_roll({:ok, account}) do
    :rand.uniform()
    |> check_roll_verify(account)
  end

  defp check_roll_verify(roll, account) when roll > 0.85, do: {:ok, account}
  defp check_roll_verify(_roll, _account), do: {:error, "Failed roll"}

  defp update({:error, _reason} = error), do: error
  defp update({:ok, account}) do
    account
    |> update_global_settings()
    |> update_account()
  end

  defp update_global_settings(account) do
    Date.utc_today()
    |> Date.to_string()
    |> set_discordia_tech_demo_last_invite()

    account
  end

  defp update_account(account) do
    {:ok, _settings} =
      account
      |> Database.AccountSettings.get()
      |> Database.AccountSettings.modify(%{discordia_is_invited_tech_demo: true})

    account
  end

  defp send_invite(key, id) do
    dm_channel =
      id
      |> Discord.get_dm_channel()
      |> Map.get(:id)

    :timer.sleep(5000)
    "hey, pssst..."
    |> Discord.send(dm_channel)

    :timer.sleep(5000)
    "You want to try out the **Land of Discordia 2** tech demo?"
    |> Discord.send(dm_channel)

    :timer.sleep(3000)
    "Send the code `#{key}` to <@468616309521776659>"
    |> Discord.send(dm_channel)

    "<@#{id}> has received an invite to the Land of Discordia Tech Demo"
    |> Discord.send(Discord.get_dm_channel(105094546005696512).id)

    {:noreply, {}}
  end

  defp set_discordia_tech_demo_last_invite(date),
    do: Database.set_global("discordia_tech_demo_last_invite", :string_value, date)
  defp get_discordia_tech_demo_last_invite(),
    do: Database.get_global("discordia_tech_demo_last_invite", :string_value, "2020-01-01")
end
