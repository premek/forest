return require 'lib.hump.class' {
  __includes = {require "level.level"},

  mapfile = "tutorial01",

  chars = {
    (require "char.shaman")(4*32, 7*32),
  }
}
