local love = love
local Character = require "char.character"

return require 'lib.hump.class' {
  __includes = {Character},
  img = "img/shaman.png",

  animate = function(self, dt)
    if self.grounded and self.speed.x ~= 0 then
      self.counters.anim = self.counters.anim + dt
      self.currentQuadNum = math.floor(self.counters.anim*self.speed.x*.2) % #self.quads+1
    else
      self.currentQuadNum = 1
    end
  end,

  handleControls = function(self, dt)
    -- TODO where to use DT and where not?
    if self.grounded and love.keyboard.isDown('up') then
      self.speed.y = self.speed.y - 4
    end
    if love.keyboard.isDown('left') then
      self.speed.x = self.speed.x - .4
      self.facing = -1
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .4
      self.facing = 1
    end
  end,

}
