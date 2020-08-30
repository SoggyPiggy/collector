import Database

set = create_set(%{name: "Events", folder_dir: "events"})

historical_events = create_set(set, %{name: "Historical 1", folder_dir: "historical_01"})

historical_events |> create_coin(%{name: "A Dream", file_dir: "a-dream"})
historical_events |> create_coin(%{name: "Bataille Lizaine", file_dir: "bataille-lizaine"})
historical_events |> create_coin(%{name: "Fall of the Berlin Wall", file_dir: "berlin-wall"})
historical_events |> create_coin(%{name: "Great Library of Alexandria", file_dir: "burning-alexandrian-library"})
historical_events |> create_coin(%{name: "Great Migration of 1843", file_dir: "emigration"})
historical_events |> create_coin(%{name: "Caste Separation Protest", file_dir: "fall-of-constantinople"})
historical_events |> create_coin(%{name: "Hidenburg", file_dir: "ghandi-caste-seperation"})
historical_events |> create_coin(%{name: "D-Day", file_dir: "hidenburg"})
historical_events |> create_coin(%{name: "The Fall of Constantinople", file_dir: "normandy"})
historical_events |> create_coin(%{name: "Woodstock '69", file_dir: "woodstuck"})
