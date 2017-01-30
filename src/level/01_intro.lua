local Level = require "level"

return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/intro.lua",
  name = "intro", -- todo get from filename

}
