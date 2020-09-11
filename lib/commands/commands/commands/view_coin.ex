defmodule Commands.Command.ViewCoin do
  @command %Commands.Command{
    id: :view_coin,
    title: "View",
    description: "View a coin using it's reference ID",
    aliases: ["v", "view", "viewcoin", "view-coin"],
    examples: [">v 00f6"]
  }

  def module(), do: @command

  def execute("", _), do: nil
  def execute(coin_reference, {account, message}) do
    coin_reference
    |> get_coin()
    |> check_owner(account)
    |> send_reply(message)
  end

  def get_coin(reference) do
    reference
    |> Database.CoinInstance.get()
    |> get_coin_verify()
  end

  def get_coin_verify({:ok, item}), do: get_coin_verify(item)
  def get_coin_verify(nil), do: {:error, "coin reference is invalid"}
  def get_coin_verify(%Database.Repo.CoinInstance{} = coin_instance), do: {:ok, coin_instance}

  def check_owner({:error, _reason} = error, _account), do: error
  def check_owner({:ok, coin_instance}, account) do
    coin_instance
    |> Database.CoinInstance.owner?(account)
    |> check_owner_verify(coin_instance)
  end

  def check_owner_verify(false, _coin_instance), do: {:error, "this is not your coin"}
  def check_owner_verify(true, coin_instance), do: {:ok, coin_instance}

  def send_reply({:error, reason}, %{author: %{id: id}} = message),
    do: Discord.send("<@#{id}>, #{reason}", :reply, message)
  def send_reply({:ok, coin_instance}, %{author: %{id: id}} = message),
    do: Discord.send("<@#{id}>", coin_instance, :reply, message)
end
