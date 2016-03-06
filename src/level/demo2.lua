local maputils = require "maputils"

return require 'lib.hump.class' {
  __includes = {require "level"},

  mapfile = "map/demo2.lua",

    action = function(self, char, item)
      if char.name == "shaman" and item.name == "door" and char.inventory.key then -- TODO inventory check
        char.inventory.key = nil
        maputils.removeObjectsByName(self.map, self.world, "door")
      end
      if char.name == "snake" and item.name == "openwall" then
        maputils.removeObjectsByName(self.map, self.world, "snakeground")
      end
    end,

}
