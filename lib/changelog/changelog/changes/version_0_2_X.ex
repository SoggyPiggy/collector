defmodule Changelog.Change.Version_0_2_X do
  @version %Changelog.MajorMinor{
    version: "0.2",
    name: "Baby Steps",
    patches: [
      %Changelog.Patch{
        version: "0",
        notes: [
          {"Whats New", [
            "A couple of things now use Base36 to reference itself for easier typing",
            "You can use the collection command to view all the coins you've collected",
            "Using the view coin command you can view a coin you've collected"
          ]},
          {"Added", [
            "References to suggestions",
            "References to coin instances",
            "Command View",
            "Command Collection",
            "A surprise"
          ]},
          {"Changed", [
            "Help command now displays the main alias of a command in the list",
            "Suggestion IDs are now shown as their references",
            "Modified a good portion of the internal coding structure"
          ]},
          {"WIP Features", [
            "proper command argument handling",
            "improvement of already added commands",
            "more features",
            "Additional ways of collecting coins",
            "Visual indication of coin condition"
          ]}
        ]
      }
    ]
  }

  def module(), do: @version
end
