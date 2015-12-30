local maputils = require "maputils"

local Level = require "level.level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/tutorial02.lua",

  load = function(self)
    self.chars = {
      (require "char.shaman")(2*32, 4*32),
    }
    self.chars[1].isControlled = true
  end,

  action = function(self, char, item)
    if item.name == "door" and char.inventory.key then -- TODO inventory check
      char.inventory.key = nil
      maputils.removeObjectsByName(self.map, self.world, "door")
    end
    if item.name == "finish" then self.finished = true end
  end,

}
