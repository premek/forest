local maputils = require "maputils"
local Signal = require 'lib.hump.signal'

local Level = require "level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/tutorial02.lua",

  action = function(self, char, item)
    if item.name == "door" then
      if char.inventory.key then -- TODO inventory check
        char.inventory.key = nil
        maputils.removeObjectsByName(self.map, self.world, "door")
        Signal.emit("door-open", item, char)
      else
        Signal.emit("door-locked", item, char)
      end
    end
  end,
}
