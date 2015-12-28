local love = love

return require 'lib.hump.class' {
  __includes = {require "char.character"},

  --init = function(self, world, img, x, y)
  --  Character.init(self, world, img, x, y)
  --end,

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
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .4
    end
  end,

  collideWith = function(self, other, col)
    if other.properties and other.properties.collectible then
      print("Collect", other.properties.item, other.x, other.y) -- TODO -- FIXME walking is wierd here
      return
    end

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

--D = Class{__includes = {A,B}}
--instance = D()
--instance:foo() -- prints 'foo'
--instance:bar() -- prints 'bar'
