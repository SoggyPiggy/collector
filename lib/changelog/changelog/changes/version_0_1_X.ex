defmodule Changelog.Change.Version_0_1_X do
  @version %Changelog.MajorMinor{
    version: "0.1",
    name: "The Rebirth",
    patches: [
      %Changelog.Patch{
        version: "3",
        notes: [
          {"Fixed", [
            "Fixed directory references which caused some coins to not load"
          ]}
        ]
      },
      %Changelog.Patch{
        version: "2",
        notes: [
          {"Changed", [
            "Added more aliases to patch notes command"
          ]},
          {"Fixed", [
            "Fixed coin art loading problem causing the discord message to not appear. (Fixes what seems like the user never collected)"
          ]}
        ]
      },
      %Changelog.Patch{
        version: "1",
        notes: [
          {"Whats New", [
            "Being the initial patch of the bot this is here to let you know the differences between the old and new bot.",
            "The new bot requires you to register to use it as to not include every dicord user as a possible collector",
            "You can still use the help command to view the commands you can use.",
            "The help command can/will alter its contents depending on whats possible for the given user",
            "Coins are what is being collected now",
            "You can only collect one coin a day",
            "The time to collect your free coin is at 8pm EST",
            "Your old data is saved, but will play no part in this new bot since everything is a different system",
          ]},
          {"Added", [
            "Help command",
            "Register command",
            "Collect command",
            "Suggest command",
            "8 Core Sets",
            "10 Sub Sets",
            "18 Sets in total",
            "95 coins",
          ]},
          {"WIP Features", [
            "Ways to view obtained coins",
            "Additional ways of collecting coins",
            "Visual indication of coin condition",
          ]}
        ]
      },
      %Changelog.Patch{
        version: "0",
        notes: [
          {"First Bulid", ["The first push to the server"]}
        ]
      }
    ]
  }

  def module(), do: @version
end
