defmodule Commands.Command do
  defstruct(
    id: :error,
    category: "Undefined",
    title: "Undefined",
    description: "Undefined",
    aliases: [],
    examples: [],
    active: true,
    for_registered: true,
    for_unregistered: false,
    for_admin_only: false
  )
end
