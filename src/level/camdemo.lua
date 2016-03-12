local maputils = require "maputils"
local Signal = require 'lib.hump.signal'

return require 'lib.hump.class' {
  __includes = {require "level"},

  mapfile = "map/camdemo.lua",

}
