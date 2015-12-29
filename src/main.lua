local love = love
local camera = require 'lib.hump.camera'

require "util"


local debug = false

local cam, levels

local zoom = 2

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setDefaultFilter("nearest")

  love.graphics.setNewFont( 10 )
  cam = camera(0,0, zoom)

  levels = { -- XXX just classes not instances?
    require "level.02_test"
  }
  levels.current = levels[1]
  levels.current:init()
end

function love.update(dt)
  levels.current:update(dt)
  -- FIXME where to? cameraQ
  levels.current.world.shake = math.max(0, (levels.current.world.shake or 0) - dt)
end


local drawVector = function(r,g,b, w, pos, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(pos.x, pos.y, pos.x+v.x*10, pos.y+v.y*10)
end

function love.draw()
  cam:lookAt(love.graphics.getWidth()*.5/zoom,love.graphics.getHeight()*.5/zoom)
  -- FIXME where to?
  cam:move(math.random(-levels.current.world.shake*2,levels.current.world.shake*2),
           math.random(-levels.current.world.shake*13,levels.current.world.shake*13)) -- FIXME decreasing amptitude, not random

  cam:attach()
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.scale(2)
  --map:setDrawRange(0, 0, windowWidth, windowHeight) --culls unnecessary tiles
  levels.current:draw()

  if debug then
    love.graphics.setLineWidth(.5)
    for _, v in ipairs(levels.current.world:getItems()) do
      local b = v.layer and v.layer.name == "objects" and 255 or 0;
      love.graphics.setColor(255, 0, b, 20)
      love.graphics.rectangle("fill", levels.current.world:getRect(v))
      love.graphics.setColor(255, 0, b)
      love.graphics.rectangle("line", levels.current.world:getRect(v))
    end
    for _, ch in ipairs(levels.current.chars) do
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
    levels.current.chars[current].isControlled = false
    current = (current%#levels.current.chars)+1
    levels.current.chars[current].isControlled = true
  end
end)(1) -- muhehehehe

function love.keypressed(key)
  if key=='tab' then switchPlayer() end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
