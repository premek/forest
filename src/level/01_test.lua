local Level = require "level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/tutorial01.lua",

}
