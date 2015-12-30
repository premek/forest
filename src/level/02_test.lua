local maputils = require "maputils"

return require 'lib.hump.class' {
  __includes = {require "level.level"},

  mapfile = "map/green.lua",

  load = function(self)
    self.chars = {
      (require "char.shaman")(2*32, 3*32),
      (require "char.flappyflap")(250, 64),
      (require "char.snake")(96, 196),
    }
    self.chars[1].isControlled = true
  end,

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
