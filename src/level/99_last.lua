local Level = require "level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/last.lua",

  action = function(self, moving, other)
    if other.type=="action" and other.name == "button" then
      --print("button pressed", moving.type, moving.name)

    end
  end,

}
