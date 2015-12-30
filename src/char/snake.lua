local love = love
local Character = require "char.character"
local maputils = require "maputils"

return require 'lib.hump.class' {
  __includes = {Character},
  type = "snake",
  img = "img/snake.png",
  inventoryCapacity = 0,

  handleControls = function(self, dt)
    -- TODO where to use DT and where not?
    if love.keyboard.isDown('left') then
      self.speed.x = self.speed.x - .2
      self.facing = -1
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .2
      self.facing = 1
    end
  end,

  getCollisionType = function(item, other)
    if other.type == "action"
    or other.type == "snakeground" then
      return 'cross'
    else return "slide"
    end
  end,

}
