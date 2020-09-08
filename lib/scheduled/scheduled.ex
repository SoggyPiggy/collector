defmodule Scheduled do
  defdelegate run_evaluate_coin_values(), to: Scheduled.EvaluateCoinValues, as: :run
end
