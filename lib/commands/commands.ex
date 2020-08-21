defmodule Commands do
  alias Commands.Organiser

  defdelegate get(id), to: Organiser
  defdelegate get(id, is_user_registered), to: Organiser
  defdelegate commands(), to: Organiser
  defdelegate commands(is_registered), to: Organiser
end
