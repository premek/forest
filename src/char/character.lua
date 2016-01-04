local love = love
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?

return require 'lib.hump.class' {
  type = "char",
  counters = {
    anim = 0
  },
  quadsNum = 4,
  currentQuadNum = 1,
  facing = 1,
  grounded = false,
  isControlled = false,
  inventory = nil, -- FIXME

  init = function(self, x, y, w, h, name)
    print("Creating character", self.img)
    self.x = x or 0
    self.y = y or 0
    self.width = w or 32
    self.height = h or 32
    self.name = name

    self.speed = vector(0,0)
    self.inventory = {}
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
    self:animate(dt)
    if self.isControlled then self:handleControls(dt) end
  end,

  animate = function(self, dt) end,

  collect = function(self, itemname)
    -- TODO inventory count check
    local c = 0
    for _,amount in pairs(self.inventory) do c = c + amount end
    if self.inventoryCapacity and self.inventoryCapacity <= c then return false end

    self.inventory[itemname] = (self.inventory[itemname] or 0) + 1
    return true
  end,

  collision = function(self, other)
    if self.isControlled and other.type == "char" then print(other.name) end
  end,

  draw = function(self)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.image,
      self.quads[self.currentQuadNum],
      self.x+self.width/2-self.width/2*self.facing,
      self.y,
      0,
      self.facing or 1,
      1)

    if self.isControlled then
      love.graphics.setColor(255,255,255, 60-60*self.speed:len())
      love.graphics.setLineWidth(7)
      love.graphics.circle("line",
        self.x + self.width/2,
        self.y  + self.width/2,
        self.width*.9)
      love.graphics.setColor(0,0,0, 30-30*self.speed:len())
      love.graphics.setLineWidth(.5)
      love.graphics.circle("line",
        self.x + self.width/2,
        self.y  + self.width/2,
        self.width)
    end
    --
    -- if false and self.isControlled then
    --   love.graphics.setColor(0,255,0)
    --   love.graphics.setLineWidth(2)
    --   love.graphics.line(
    --     self.pos.x + 4,
    --     self.pos.y - 8,
    --     self.pos.x + self.width - 4,
    --     self.pos.y-8)
    -- end
  end
}
