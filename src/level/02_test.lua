local maputils = require "maputils"
local Signal = require 'lib.hump.signal'

return require 'lib.hump.class' {
  __includes = {require "level"},

  mapfile = "map/demo.lua",

  action = function(self, char, item)
    if char.name == "shaman" and item.name == "door" then
      if char.inventory.key then -- TODO inventory check
        char.inventory.key = nil
        maputils.removeObjectsByName(self.map, self.world, "door")
        Signal.emit("door-open", item, char)
      else
        Signal.emit("door-locked", item, char)
      end
    end
    if char.name == "snake" and item.name == "openwall" then
      maputils.removeObjectsByName(self.map, self.world, "snakeground")
    end
  end,

  getLevelCollisionType = function(self, char, other)
    if char.name == "snake" and other.name == "snakeground" then return 'cross' end
  end,

}
