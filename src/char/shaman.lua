local love = love

return require 'lib.hump.class' {
  __includes = {require "char.character"},

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
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .4
    end
  end,

  action = function(self, item, action)
    if(action == "finish") then love.event.quit() end
  end,

  collideWith = function(self, other, col)
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
