defmodule DatabaseTest do
  use ExUnit.Case, async: true
  doctest Database

  alias Database.Seeding.{Updater, Generator}
  alias Database.Seeds

  def tuplify(item, tuple \\ {}), do: Tuple.append(tuple, item)

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Database.Repo)
  end

  test "seeds update without failure" do
    assert {:ok, version} = Updater.update()
    assert version |> is_integer()
  end

  test "seeds point to a file" do
    Updater.update()

    assert [] = (
      Database.Repo.Coin
      |> Database.Repo.all()
      |> Enum.map(fn coin ->
        File.cwd!()
        |> Path.join("assets/static/")
        |> Path.join(Database.get_coin_art_path(coin, ".png"))
        |> File.exists?()
        |> tuplify()
        |> Tuple.append(coin.name)
        |> Tuple.append(Database.get_coin_art_path(coin))
      end)
      |> Enum.filter(fn {exists, _name, _dir} -> !exists end)
    )
  end
end
