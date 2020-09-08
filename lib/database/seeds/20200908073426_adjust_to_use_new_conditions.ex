defmodule Database.Seeds.AdjustToUseNewConditions20200908073426 do
  def version(), do: 20200908073426

	def run() do
    Database.CoinInstance.all()
    |> Enum.each(fn instance ->
      original_roll = instance.condition |> ungenerate_condition()
      new_condition = original_roll |> generate_condition()

      instance
      |> Database.CoinInstance.modify(%{
        condition_roll: original_roll,
        condition_natural: new_condition,
        condition: new_condition
        })
    end)
  end

  defp generate_condition(0), do: 0
  defp generate_condition(1), do: 1
  defp generate_condition(x) when x < 0.5, do: 1 - generate_condition(1 - x)
  defp generate_condition(x), do: (:math.pow(2 * x - 1, 2.2) / 2) + 0.5

  defp ungenerate_condition(0), do: 0
  defp ungenerate_condition(1), do: 1
  defp ungenerate_condition(x) when x < 0.5, do: 1 - ungenerate_condition(1 - x)
  defp ungenerate_condition(x), do: 0.5 * (:math.pow((2 * x - 1) * (2 * x - 1), 1 / 6) + 1)
end
