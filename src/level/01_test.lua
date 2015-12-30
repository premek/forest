local Level = require "level.level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/tutorial01.lua",

  action = function(self, char, item)
    if item.name == "finish" then self.finished = true end
  end,

}
