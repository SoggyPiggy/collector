defmodule Database.Seeds.CreateEventsHistorical20200901045437 do
  import Database

  def version(), do: 20200901045437

	def run() do
    set = create_set(%{name: "Events", folder_dir: "events"})

    historical_events = create_set(set, %{name: "Historical", folder_dir: "historical_01"})

    create_coin(historical_events, %{name: "A Dream", file_dir: "a-dream"})
    create_coin(historical_events, %{name: "Bataille Lizaine", file_dir: "bataille-lizaine"})
    create_coin(historical_events, %{name: "Fall of the Berlin Wall", file_dir: "berlin-wall"})
    create_coin(historical_events, %{name: "Great Library of Alexandria", file_dir: "burning-alexandrian-library"})
    create_coin(historical_events, %{name: "Great Migration of 1843", file_dir: "emigration"})
    create_coin(historical_events, %{name: "Caste Separation Protest", file_dir: "fall-of-constantinople"})
    create_coin(historical_events, %{name: "Hidenburg", file_dir: "ghandi-caste-seperation"})
    create_coin(historical_events, %{name: "D-Day", file_dir: "hidenburg"})
    create_coin(historical_events, %{name: "The Fall of Constantinople", file_dir: "normandy"})
    create_coin(historical_events, %{name: "Woodstock '69", file_dir: "woodstuck"})
  end
end
