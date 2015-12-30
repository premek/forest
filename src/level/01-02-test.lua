local maputils = require "maputils"

local Level = require "level.level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/tutorial02.lua",

  action = function(self, char, item)
    if item.name == "door" and char.inventory.key then -- TODO inventory check
      char.inventory.key = nil
      maputils.removeObjectsByName(self.map, self.world, "door")
    end
    if item.name == "finish" then self.finished = true end
  end,

}
