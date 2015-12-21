local love = love
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?

return require 'lib.hump.class' {
  counters = {
    anim = 0
  },
  quads = {},
  quadsNum = 4,
  speed = vector(0,0),
  gravity = vector(0,.1),
  grounded = false,

  init = function(self, world, img, x, y)
    self.world = world
    self.img = img
    self.pos = vector(x or 0, y or 0)

    self.image = love.graphics.newImage(self.img)
    local dx, dy = self.image:getDimensions()
    for i=1,self.quadsNum do
      self.quads[i] = love.graphics.newQuad(32*(i-1), 0, 32, 32, dx, dy)
    end

    world:add(self, self.pos.x, self.pos.y, 32, 32)
  end,

  update = function(self, dt)
    if self.speed:len() < 0.1 then self.speed = vector(0,0) end

    if self.grounded and self.speed.x ~= 0 then
      self.counters.anim = self.counters.anim + dt
      self.currentQuadNum = math.floor(self.counters.anim*self.speed.x*.2) % #self.quads+1
    else
      self.currentQuadNum = 1
    end

    self.speed = self.speed + self.gravity
    -- TODO 0 friction in air, else other objects friction - implement mud, ice, ...
    self.speed.x = self.speed.x * .9
    --self.speed.y = self.speed.y * .8


    if self.grounded and love.keyboard.isDown('up') then
      self.speed.y = self.speed.y - 4
    end
    if love.keyboard.isDown('left') then
      self.speed.x = self.speed.x - .4
    end
    if love.keyboard.isDown('right') then
      self.speed.x = self.speed.x + .4
    end

    local newPos = self.pos + self.speed

    if self.speed:len() ~= 0 then

      local actualX, actualY, cols, colsNum = self.world:move(self, newPos.x, newPos.y)

      self.grounded = false -- no collisions, no jumping

      for _, col in ipairs(cols) do
        if col.normal.y < 0 then
          -- feet touched
          self.speed.y = 0
          self.grounded = true
        end
        if col.normal.y > 0 then
          -- head touched
          self.speed.y = 0
        end
        if col.normal.x ~= 0 then
          -- left or right touched
          self.speed.x = 0
        end
      end
      -- TODO some tollerance - to be able to jump up between 2 tiles

      self.pos.x = actualX
      self.pos.y = actualY


    end

  end,

  draw = function(self)
    love.graphics.draw(self.image,
      self.quads[self.currentQuadNum],
      self.pos.x,
      self.pos.y)
  end
}

--D = Class{__includes = {A,B}}
--instance = D()
--instance:foo() -- prints 'foo'
--instance:bar() -- prints 'bar'
