defmodule Changelog.Organiser do
  alias Changelog.Change
  @versions [
    Change.Version_0_2_X,
    Change.Version_0_1_X
  ]

  def get_latest(), do: get_log(0)

  def get_previous(num), do: get_log(num)

  def list(), do: Enum.map(@versions, &get_log_module/1)

  def get_version(%Changelog.MajorMinor{} = patch \\ get_latest()),
    do: "#{patch.version}.X"

  defp get_log(num) do
    @versions
    |> Enum.at(num)
    |> get_log_module()
  end

  defp get_log_module(log), do: log.module()
end
