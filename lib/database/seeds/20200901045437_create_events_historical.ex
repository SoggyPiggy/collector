defmodule Database.Seeds.CreateEventsHistorical20200901045437 do
  alias Database.{Coin, Set}

  def version(), do: 20200901045437

	def run() do
    set = Set.new(%{name: "Events", folder_dir: "events"})

    historical_events = Set.new(set, %{name: "Historical", folder_dir: "historical_01"})

    Coin.new(historical_events, %{name: "A Dream", file_dir: "a-dream"})
    Coin.new(historical_events, %{name: "Bataille Lizaine", file_dir: "bataille-lizaine"})
    Coin.new(historical_events, %{name: "Fall of the Berlin Wall", file_dir: "berlin-wall"})
    Coin.new(historical_events, %{name: "Great Library of Alexandria", file_dir: "burning-alexandrian-library"})
    Coin.new(historical_events, %{name: "Great Migration of 1843", file_dir: "emigration"})
    Coin.new(historical_events, %{name: "Caste Separation Protest", file_dir: "fall-of-constantinople"})
    Coin.new(historical_events, %{name: "Hidenburg", file_dir: "ghandi-caste-seperation"})
    Coin.new(historical_events, %{name: "D-Day", file_dir: "hidenburg"})
    Coin.new(historical_events, %{name: "The Fall of Constantinople", file_dir: "normandy"})
    Coin.new(historical_events, %{name: "Woodstock '69", file_dir: "woodstuck"})
  end
end
