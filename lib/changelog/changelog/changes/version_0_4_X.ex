defmodule Changelog.Change.Version_0_4_X do
  @version %Changelog.MajorMinor{
    version: "0.4",
    name: "Big PP",
    patches: [
      %Changelog.Patch{
        version: "1",
        notes: [
          {"Fixed", [
            "Missing commit for patch notes"
          ]},
        ]
      },
      %Changelog.Patch{
        version: "0",
        notes: [
          {"Whats New", [
            "Added Most/Least valuable coin to profile",
            "You can now compare two profiles",
            "If you have a coin that was a mistake or is an error, the value will now reflect that",
            "Yeah... the guide command has been added, but it's really shit, but it'll do",
            "If you want to view the different sets its now possible with the sets command"
          ]},
          {"Added", [
            "Guide Command",
            "Sets Command",
            "PP Compare Command"
          ]},
          {"Changed", [
            "Tweaked coin value assestment algorithm",
            "MVC to Profile command",
            "LVC to profile command",
          ]},
          {"Fixed", [
            "Suggestions not reccording usernames"
          ]},
          {"WIP Features", [
            "Additional ways of collecting coins",
            "Visual indication of coin condition"
          ]}
        ]
      }
    ]
  }

  def module(), do: @version
end
