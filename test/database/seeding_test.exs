defmodule Database.SeedingTest do
  use Collector.DataCase, async: true
  alias Database.Seeding.Updater

  def tuplify(item, tuple \\ {}), do: Tuple.append(tuple, item)

  test "database seeding update" do
    assert {:ok, version} = Updater.update()
    assert true = version |> is_integer()
  end

  test "database seeds - point to a real file" do
    Updater.update()

    assert [] = (
      Database.Repo.Coin
      |> Database.Repo.all()
      |> Enum.map(fn coin ->
        File.cwd!()
        |> Path.join("assets/static/")
        |> Path.join(Collector.get_asset(coin, ".png"))
        |> File.exists?()
        |> tuplify()
        |> Tuple.append(coin.name)
        |> Tuple.append(Collector.get_asset(coin))
      end)
      |> Enum.filter(fn {exists, _name, _dir} -> !exists end)
    )
  end
end
