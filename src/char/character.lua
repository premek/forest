local love = love
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?

return require 'lib.hump.class' {
  counters = {
    anim = 0
  },
  quadsNum = 4,
  currentQuadNum = 1,
  facing = 1,
  grounded = false,
  isControlled = false,
  inventory = {}, -- FIXME

  init = function(self, x, y, w, h)
    print("Creating character", self.img)
    self.pos = vector(x or 0, y or 0)
    self.size = vector(w or 32, h or 32)

    self.speed = vector(0,0)
    self.gravity = vector(0,.1)
  end,

  load = function(self)
    print("Loading character", self.img)
    self.image = love.graphics.newImage(self.img)
    local dx, dy = self.image:getDimensions()
    self.quads = {}
    for i=1,self.quadsNum do
      self.quads[i] = love.graphics.newQuad(32*(i-1), 0, 32, 32, dx, dy)
    end
  end,

  update = function(self, dt)
    if self.speed:len() < 0.1 then self.speed = vector(0,0) end

    self:animate(dt)

    self.speed = self.speed + self.gravity
    -- TODO 0 friction in air, else other objects friction - implement mud, ice, ...
    self.speed.x = self.speed.x * .9
    --self.speed.y = self.speed.y * .8

    --if self.speed.x ~= 0 then
  --    self.facing = (math.abs(self.speed.x)) / self.speed.x
    --end

    if self.isControlled then self:handleControls(dt) end

  end,

  animate = function(self, dt) end,

  getCollisionType = function(item, other)
    if other.type == "action"
    or other.type == "collect" then
      return 'cross'
    else return "slide"
    end
    --if     other.isCoin   then return 'cross'
    --elseif other.isWall   then return 'slide'
    --elseif other.isExit   then return 'touch'
    --elseif other.isSpring then return 'bounce'
    --end
    -- else return nil
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

  collect = function(self, item)
    if item.layer and item.layer.name == "objects"
      and item.type == "collect" then

        local c = 0
        for _,amount in pairs(self.inventory) do c = c + amount end
        if self.inventoryCapacity and self.inventoryCapacity <= c then return false end

        self.inventory[item.name] = (self.inventory[item.name] or 0) + 1
        return true
    end
  end,

  draw = function(self)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.image,
      self.quads[self.currentQuadNum],
      self.pos.x+self.size.x/2-self.size.x/2*self.facing,
      self.pos.y,
      0,
      self.facing or 1,
      1)

    if self.isControlled then
      love.graphics.setColor(255,255,255, 60-60*self.speed:len())
      love.graphics.setLineWidth(7)
      love.graphics.circle("line",
        self.pos.x + self.size.x/2,
        self.pos.y  + self.size.x/2,
        self.size.x*.9)
      love.graphics.setColor(0,0,0, 30-30*self.speed:len())
      love.graphics.setLineWidth(.5)
      love.graphics.circle("line",
        self.pos.x + self.size.x/2,
        self.pos.y  + self.size.x/2,
        self.size.x)
    end
    --
    -- if false and self.isControlled then
    --   love.graphics.setColor(0,255,0)
    --   love.graphics.setLineWidth(2)
    --   love.graphics.line(
    --     self.pos.x + 4,
    --     self.pos.y - 8,
    --     self.pos.x + self.size.x - 4,
    --     self.pos.y-8)
    -- end
  end
}
