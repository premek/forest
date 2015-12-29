return require 'lib.hump.class' {
  __includes = {require "level.level"},

  mapfile = "green",

  chars = {
    (require "char.shaman")(4*32, 7*32),
    (require "char.flappyflap")(96, 64),
    (require "char.snake")(96, 196),
  }
}
