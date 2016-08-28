local Level = require "level"

return require 'lib.hump.class' {
  __includes = {Level},

  mapfile = "map/intro.lua",

  introCutscene = function(slf, say)
      say(slf.chars[1], "Did you see my wife?")
      say(slf.chars[2], "No...")
      say(slf.chars[2], "But you can go\nlook for her over there")
      say(slf.chars[2], "Use arrow keys for that")
      say(slf.chars[1], "What?")

  end

}
