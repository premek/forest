local love = love
local vector = require 'lib.hump.vector'

require "lib.util"

require "sfx"


local debug = false

local levels, level, music

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setDefaultFilter("nearest")

  love.graphics.setNewFont( 14 )

  levels = {
    require "level.01_test",
    require "level.camdemo",
    require "level.tut3",
    require "level.tut4",
    require "level.01-02-test",
    require "level.demo2",
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

  music = love.audio.newSource( 'music/03 - Solxis - Rainforest.mp3', 'stream' )
  music:setLooping( true )
  music:setVolume(.7)
  music:play()

end

function love.update(dt)
  level:update(dt)
  -- TODO signals
  if level.finished then levels:next(); level = levels:load() end
  if level.dead then level = levels:load() end
end


local drawVector = function(r,g,b, w, x, y, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(x, y, x+v.x*10, y+v.y*10)
end


local drawDebug = function()
  love.graphics.setColor(0,255,0, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  level.cam:attach()

  for _, v in ipairs(level.world:getItems()) do
    local b = v.layer and v.layer.name == "objects" and 255 or 0;
    love.graphics.setColor(255, 0, b, 20)
    love.graphics.rectangle("fill", level.world:getRect(v))
    love.graphics.setColor(255, 0, b)
    love.graphics.rectangle("line", level.world:getRect(v))
  end
  for _, ch in ipairs(level.map.layers.objects.objects) do
    if ch.speed then drawVector(0,255,0, 2, ch.x, ch.y, ch.speed) end

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
  level.cam:detach()

end


function love.draw()
  level:draw()
  if debug then drawDebug() end
end

function love.keypressed(key)
  level:keypressed(key)
  if key=='d' then debug = not debug end
  if key=='r' then level = levels:load() end
  if key=='escape' then love.event.quit() end
  if key=='.' then levels:next(); level = levels:load() end

end
