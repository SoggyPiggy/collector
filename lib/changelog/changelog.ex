defmodule Changelog do
  defdelegate get_latest(), to: Changelog.Organiser
  defdelegate get_previous(number_back), to: Changelog.Organiser
end
