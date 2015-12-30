local Level = require "level.level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/last.lua",

  load = function(self)
    self.chars = {
      (require "char.shaman")(1*32, 5*32),
    }
    self.chars[1].isControlled = true
  end,

}
