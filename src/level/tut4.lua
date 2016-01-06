return require 'lib.hump.class' {
  __includes = {require "level"},

  mapfile = "map/tutorial04.lua",

  action = function(self, moving, other)
    if other.name == "lava" then
      print("died")
      self.dead = true
    end
  end
}
