local Level = require "level.level"
return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/last.lua",

}
