local maputils = require "maputils"
local Signal = require 'lib.hump.signal'

return require 'lib.hump.class' {
  __includes = {require "level"},

  saidThatAlready = false,

  mapfile = "map/demo2.lua",

    action = function(level, char, item)
      if char.name == "shaman" and item.name == "door" then
        if char.inventory.key then -- TODO inventory check
          char.inventory.key = nil
          maputils.removeObjectsByName(level.map, level.world, "door")
          Signal.emit("door-open", item, char)
        else
          Signal.emit("door-locked", item, char)
          -- TODO wait here after door locked message
          level:storyCutscene("demo2_door")
        end
      end
    end,

    collected = function(level, char, item)
      if char.name == 'flappyflap' and not level.saidThatAlready then
        level.saidThatAlready = true -- FIXME eew
        level:storyCutscene("demo2_bird_collect")
      end
    end,

}
