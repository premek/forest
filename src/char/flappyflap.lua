local love = love
local Character = require "char.character"

return require 'lib.hump.class' {
  __includes = {Character},
  img = "img/flappyflap.png",

  animate = function(self, dt)
    if not self.grounded then
      self.counters.anim = self.counters.anim + math.abs(self.speed.y-3 ) *3* dt
      self.currentQuadNum = math.floor(self.counters.anim) % #self.quads+1
    elseif self.grounded then
      self.currentQuadNum = 1
    end
  end,

  update = function(self, dt)
    Character.update(self, dt)
    if self.holding then
      self.holding.x = self.x
      self.holding.y = self.y+10
      self.holding.speed.x = 0
      self.holding.speed.y = 0
    end
  end,

  collect = function(self, item)
    self.holding = item
    --self.inventory[item.name] = 1
    --return true
    return false -- do not collect / remove item
  end,

  handleControls = function(self, dt)
    -- TODO where to use DT and where not?
    if love.keyboard.isDown('up') then
      self.speed.y = self.speed.y - .2
    end
    if love.keyboard.isDown('left') then
      self.speed.x = self.speed.x - .4
      self.facing = -1
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .4
      self.facing = 1
    end
    if love.keyboard.isDown('space') then
      if self.holding then
        self.holding.y = self.holding.y + 33 -- TODO: do not collect for a while after dropping?
        self.holding = nil
        end
    end
  end,

}
