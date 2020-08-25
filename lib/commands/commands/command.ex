defmodule Commands.Command do
  defstruct(
    id: :error,
    category: "Undefined",
    title: "Undefined",
    description: "Undefined",
    aliases: [],
    examples: [],
    is_public: true,
    for_registered: true,
    for_unregistered: false
  )
end
