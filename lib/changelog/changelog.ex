defmodule Changelog do
  defdelegate list(), to: Changelog.Organiser
  defdelegate get_latest(), to: Changelog.Organiser
  defdelegate get_previous(number_back), to: Changelog.Organiser
  defdelegate get_version(), to: Changelog.Organiser
  defdelegate get_version(version), to: Changelog.Organiser
end
