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
    require "level.tut3",
    require "level.tut4",
    require "level.01-02-test",
    require "level.02_test",
    require "level.99_last",
    current = 1,
    next = function(self)
      self.current = (self.current or 0) + 1
    end,
    load = function(self)
      return self[self.current]() -- instantiate the level
    end,
  }
  level = levels:load()
end

function love.update(dt)
  level:update(dt)

  -- FIXME where to? cameraQ
  level.world.shake = math.max(0, (level.world.shake or 0) - dt)

  if level.finished then levels:next(); level = levels:load() end
  if level.dead then level = levels:load() end
end


local drawVector = function(r,g,b, w, x, y, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(x, y, x+v.x*10, y+v.y*10)
end


local drawDebug = function()
  love.graphics.setLineWidth(.5)
  love.graphics.setColor(0,255,0, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  for _, v in ipairs(level.world:getItems()) do
    local b = v.layer and v.layer.name == "objects" and 255 or 0;
    love.graphics.setColor(255, 0, b, 20)
    love.graphics.rectangle("fill", level.world:getRect(v))
    love.graphics.setColor(255, 0, b)
    love.graphics.rectangle("line", level.world:getRect(v))
  end
  for _, ch in ipairs(level.movables) do
    drawVector(0,255,0, 2, ch.x, ch.y, ch.speed)

    love.graphics.setColor(0,0,255, 255)
    if ch.name then love.graphics.print(ch.name, ch.x, ch.y+ch.height) end

    if ch.inventory then
      local li=1
      for item, amount in pairs(ch.inventory) do
        love.graphics.print(item .. " x"..amount, ch.x, ch.y+ch.height+li*10)
        li = li + 1
      end
    end
  end
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
  if debug then drawDebug() end
  cam:detach()
end

function love.keypressed(key)
  level:keypressed(key)
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
