local love = love
local Character = require "char.character"
local vector = require "lib.hump.vector"

return require 'lib.hump.class' {
  __includes = {Character},
  img = "img/flappyflap.png",
  cannotCollect = 0,

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
    self.cannotCollect = self.cannotCollect - dt
    if self.holding then
      -- if holded item is held back by something else (wall, ...) and cannot move with the holder
      local diff = vector(self.holding.x, self.holding.y) - vector(self.x, self.y)
      self.x = self.x + diff.x/2
      -- move the holded item
      self.holding.speed.x = self.speed.x
      self.holding.speed.y = self.speed.y
      self.holding.y = self.y+25
      self.holding.x = self.x

    end
  end,

  collect = function(self, item)
    if self.cannotCollect < 0 then self.holding = item end
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
        self.cannotCollect = 1
        self.holding = nil
        end
    end
  end,

}
