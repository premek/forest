local maputils = require "maputils"

return require 'lib.hump.class' {
  __includes = {require "level.level"},

  mapfile = "map/green.lua",

  action = function(self, char, item)
    if char.type == "shaman" and item.name == "door" and char.inventory.key then -- TODO inventory check
      char.inventory.key = nil
      maputils.removeObjectsByName(self.map, self.world, "door")
    end
    if char.type == "shaman" and item.name == "finish" then self.finished = true end
    if char.type == "snake" and item.name == "openwall" then
      maputils.removeObjectsByName(self.map, self.world, "snakeground")
    end
  end,

  getLevelCollisionType = function(self, char, other)
    if char.type == "snake" and other.name == "snakeground" then return 'cross' end
  end,

}
