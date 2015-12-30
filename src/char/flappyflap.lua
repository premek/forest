local love = love
local Character = require "char.character"

return require 'lib.hump.class' {
  __includes = {Character},
  inventoryCapacity = 1, -- TODO do not collect but hold, move and drop
  img = "img/flappyflap.png",

  animate = function(self, dt)
    if not self.grounded then
      self.counters.anim = self.counters.anim + math.abs(self.speed.y-3 ) *3* dt
      self.currentQuadNum = math.floor(self.counters.anim) % #self.quads+1
    elseif self.grounded then
      self.currentQuadNum = 1
    end
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
      local i,a,c = pairs(self.inventory) -- FIXME do it nicer
      local item, _ = i(a,c)
      if item then
        print("drop " .. item) -- TODO

        self.inventory = {}
      end
    end
  end,

}
