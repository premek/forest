local love = love
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?

return require 'lib.hump.class' {
  counters = {
    anim = 0
  },
  quads = {},
  quadsNum = 4,
  currentQuadNum = 1,
  facing = 1,
  grounded = false,
  isControlled = false,
  inventory = {},

  init = function(self, world, map, img, x, y, w, h)
    self.world = world
    self.map = map
    self.img = img
    self.pos = vector(x or 0, y or 0)
    self.size = vector(w or 32, h or 32)

    self.speed = vector(0,0)
    self.gravity = vector(0,.1)

    self.image = love.graphics.newImage(self.img)
    local dx, dy = self.image:getDimensions()
    for i=1,self.quadsNum do
      self.quads[i] = love.graphics.newQuad(32*(i-1), 0, 32, 32, dx, dy)
    end

    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
  end,

  update = function(self, dt)
    if self.speed:len() < 0.1 then self.speed = vector(0,0) end

    self:animate(dt)

    self.speed = self.speed + self.gravity
    -- TODO 0 friction in air, else other objects friction - implement mud, ice, ...
    self.speed.x = self.speed.x * .9
    --self.speed.y = self.speed.y * .8

    if self.speed.x ~= 0 then
      self.facing = (math.abs(self.speed.x)) / self.speed.x
    end

    if self.isControlled then self:handleControls(dt) end

    local newPos = self.pos + self.speed

    if self.speed:len() ~= 0 then

      local actualX, actualY, cols, _ = self.world:move(self, newPos.x, newPos.y, self.getCollisionType)

      local original = {
        grounded = self.grounded,
        speed = self.speed:clone(),
      }

      self.grounded = false -- no collisions, no jumping

      for _, col in ipairs(cols) do
        if not self:collect(col.other) then
          self:collideWith(col.other, col)
        end
      end
      -- TODO some tollerance
      -- to be able to jump up between 2 tiles
      -- or to fall down into a hole of size of 1 tile

      self.pos.x = actualX
      self.pos.y = actualY

      if self.grounded and not original.grounded then
        -- FIXME store somewhere else than in "world"
        self.world.shake = original.speed.y * .07 - .2 -- only for long jumps
      end

    end

  end,

  collect = function(self, item)
    if item.layer and item.layer.name == "objects"
      and item.properties and item.properties.collect then
        
      local mapx, mapy = self.map:convertScreenToTile(item.x, item.y)
      mapx, mapy = mapx + 1, mapy + 1
      self.world:remove(item)
      self.map.layers.objects.data[mapy][mapx] = nil
      self.map:setSpriteBatches(self.map.layers.objects)
      self.inventory[item.properties.collect] = (self.inventory[item.properties.collect] or 0) + 1

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

    -- if false and self.isControlled then
    --   love.graphics.setColor(0,50,0, 20)
    --   love.graphics.setLineWidth(7)
    --   love.graphics.circle("line",
    --     self.pos.x + self.size.x/2,
    --     self.pos.y  + self.size.x/2,
    --     self.size.x*.9)
    -- end
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
