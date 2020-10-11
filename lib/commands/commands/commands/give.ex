defmodule Commands.Command.Give do
  @command %Commands.Command{
    id: :give,
    title: "Give",
    description: "Give a coin to an account",
    aliases: ["give"],
    examples: ["give"],
    is_public: false,
    args_strict: [
      account: :string,
      coin_ref: :string,
      name: :string,
      file_dir: :string,
      in_circulation: :boolean,
      is_error: :boolean
    ],
    args_aliases: [
      a: :account,
      c: :coin_ref,
      n: :name,
      d: :file_dir,
      i: :in_circulation,
      e: :is_error
    ],
    args_descriptions: [
      account: "Account to give the coin to",
      coin_ref: "The coin reference of the coin to give, if one not given will resort to using the rest of the arguments",
      name: "Coin.name",
      file_dir: "Coin.file_dir",
      in_circulation: "Coin.in_circulation",
      is_error: "Coin.is_error"
    ]
  }

  def module(), do: @command

  def execute(_args, {_account, _message} = _reply_data) do
    # args
    # |> OptionParser.split()
    # |> OptionParser.parse(strict: @command.args_strict, aliases: @command.args_aliases)
    # |> (fn {params, _bases, _errors} -> {:ok, params[:account], params} end).()
  end

  # defp check_account({:error, _reason} = error), do: error
  # defp check_account({:ok, account, params}), do: nil
end
