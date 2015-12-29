local love = love
local Character = require "char.character"
local maputils = require "maputils"

return require 'lib.hump.class' {
  __includes = {Character},
  img = "img/snake.png",
  inventoryCapacity = 0,

  handleControls = function(self, dt)
    -- TODO where to use DT and where not?
    if love.keyboard.isDown('left') then
      self.speed.x = self.speed.x - .2
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .2
    end
  end,

  action = function(self, item, action)
    if(action == "open") then
      maputils.removeObjectByType(self.map, self.world, "snakeground")
    end
    -- TODO the object should know who can activate it
  end,

  getCollisionType = function(item, other)
    if other.type == "action"
    or other.type == "snakeground" then
      return 'cross'
    else return "slide"
    end
  end,

  collideWith = function(self, other, col)
    if other.type == "snakeground" then return end

    if col.normal.y < 0 then
      -- feet touched
      self.speed.y = 0
      self.grounded = true
    end
    if col.normal.y > 0 then
      -- head touched
      self.speed.y = -.1
       -- this is to allow jumping in a space of size of 1 tile
       -- increase to implement 'hold/stick to ceiling'
       -- FIXME what is a good value in relation to gravity and jump speed
    end
    if col.normal.x ~= 0 then
      -- left or right touched
      self.speed.x = 0
    end
  end,
}
