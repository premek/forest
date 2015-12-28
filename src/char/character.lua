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
        local _ = false
        or self:callAction(col.other)
        or self:collect(col.other)
        or self:collideWith(col.other, col)
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

  getCollisionType = function(item, other)
    if other.type == "action" then return 'cross'
    else return "slide"
    end
    --if     other.isCoin   then return 'cross'
    --elseif other.isWall   then return 'slide'
    --elseif other.isExit   then return 'touch'
    --elseif other.isSpring then return 'bounce'
    --end
    -- else return nil
  end,

  collect = function(self, item)
    if item.layer and item.layer.name == "objects"
      and item.type == "collect" then
        self.world:remove(item)
        self.inventory[item.name] = (self.inventory[item.name] or 0) + 1
        for k,v in pairs(self.map.layers.objects.objects) do
          if v.id == item.id then
            table.remove(self.map.layers.objects.objects, k)
          end
        end
        self.map:setObjectSpriteBatches(self.map.layers.objects)
        return true
    end
  end,

  callAction = function(self, item)
    if item.layer and item.layer.name == "objects"
      and item.type == "action" then
        self:action(item, item.name)
      return true
    end
  end,

  action = function(self, item, action)
    print("Action " .. action)
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
