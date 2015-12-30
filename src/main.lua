local love = love
local camera = require 'lib.hump.camera'

require "util"


local debug = false

local cam, levels, level

local zoom = 2

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setDefaultFilter("nearest")

  love.graphics.setNewFont( 10 )
  cam = camera(0,0, zoom)

  levels = {
    require "level.01_test",
    require "level.01-02-test",
    require "level.02_test",
    require "level.99_last",
    current = 2,
    loadNext = function(self)
      self.current = (self.current or 0) + 1
      return self[self.current]() -- instantiate the level
    end
  }
  level = levels:loadNext()
end

function love.update(dt)
  level:update(dt)

  -- FIXME where to? cameraQ
  level.world.shake = math.max(0, (level.world.shake or 0) - dt)

  if level.finished then level = levels:loadNext() end
end


local drawVector = function(r,g,b, w, pos, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(pos.x, pos.y, pos.x+v.x*10, pos.y+v.y*10)
end

function love.draw()
  cam:lookAt(love.graphics.getWidth()*.5/zoom,love.graphics.getHeight()*.5/zoom)
  -- FIXME where to?
  if level.world.shake then cam:move(math.random(-level.world.shake*2,level.world.shake*2),
           math.random(-level.world.shake*13,level.world.shake*13)) -- FIXME decreasing amptitude, not random
  end
  cam:attach()
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.scale(2)
  --map:setDrawRange(0, 0, windowWidth, windowHeight) --culls unnecessary tiles
  level:draw()

  if debug then
    love.graphics.setLineWidth(.5)
    for _, v in ipairs(level.world:getItems()) do
      local b = v.layer and v.layer.name == "objects" and 255 or 0;
      love.graphics.setColor(255, 0, b, 20)
      love.graphics.rectangle("fill", level.world:getRect(v))
      love.graphics.setColor(255, 0, b)
      love.graphics.rectangle("line", level.world:getRect(v))
    end
    for _, ch in ipairs(level.chars) do
      drawVector(0,255,0, 2, ch.pos, ch.speed)

      love.graphics.setColor(0,0,255, 255)
      love.graphics.print("Inventory:", ch.pos.x, ch.pos.y+ch.size.y)
      local li=1

      for item, amount in pairs(ch.inventory) do
        love.graphics.print(item .. " x"..amount, ch.pos.x, ch.pos.y+ch.size.y+li*10)
        li = li + 1
      end
    end
  end

  cam:detach()

end


local switchPlayer = (function(current)
  return function()
    level.chars[current].isControlled = false
    current = (current%#level.chars)+1
    level.chars[current].isControlled = true
  end
end)(1) -- muhehehehe

function love.keypressed(key)
  if key=='tab' then switchPlayer() end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
