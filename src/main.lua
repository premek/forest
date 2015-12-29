local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local camera = require 'lib.hump.camera'
local Shaman = require "char.shaman"
local Flappyflap = require "char.flappyflap"
local Snake = require "char.snake"
require "util"

local debug = false

local map, world, chars, cam

local zoom = 2

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  love.graphics.setNewFont( 10 )
  cam = camera(0,0, zoom)

  love.graphics.setDefaultFilter("nearest")
  map = sti.new("map/green.lua", { "bump" })
  world = bump.newWorld()
  map:bump_init(world) 	--- Adds each collidable tile to the Bump world.
  chars = {
    Shaman(world, map, 64, 64),
    Flappyflap(world, map, 96, 64),
    Snake(world, map, 96, 196),
  }
  chars[1].isControlled = true

  --map:addCustomLayer("Sprite Layer", 3)
  -- Add data to Custom Layer
  --local spriteLayer = map.layers["Sprite Layer"]
  --spriteLayer.sprites = {
  --  --player
  --}

  -- Update callback for Custom Layer
  --function spriteLayer:update(dt)
  --  for _, sprite in pairs(self.sprites) do
  --    --sprite.r = sprite.r + math.rad(90 * dt)
  --  end
  --end

  -- Draw callback for Custom Layer
  --function spriteLayer:draw()
  --  for _, sprite in pairs(self.sprites) do
  --    --local x = math.floor(sprite.pos.x)
  --    --local y = math.floor(sprite.y)
  --    --love.graphics.draw(sprite.image, x, y)
  --  end
  --end
end

function love.update(dt)
  map:update(dt)
  for _,char in ipairs(chars) do char:update(dt) end

  world.shake = math.max(0, (world.shake or 0) - dt)
end


local drawVector = function(r,g,b, w, pos, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(pos.x, pos.y, pos.x+v.x*10, pos.y+v.y*10)
end

function love.draw()
  cam:lookAt(love.graphics.getWidth()*.5/zoom,love.graphics.getHeight()*.5/zoom)
  cam:move(math.random(-world.shake*2,world.shake*2),
           math.random(-world.shake*13,world.shake*13)) -- FIXME decreasing amptitude, not random

  cam:attach()
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.scale(2)
  --map:setDrawRange(0, 0, windowWidth, windowHeight) --culls unnecessary tiles
  map:draw()
  for _,char in ipairs(chars) do
    char:draw()
  end

  if debug then
    love.graphics.setLineWidth(.5)
    for _, v in ipairs(world:getItems()) do
      local b = v.layer and v.layer.name == "objects" and 255 or 0;
      love.graphics.setColor(255, 0, b, 20)
      love.graphics.rectangle("fill", world:getRect(v))
      love.graphics.setColor(255, 0, b)
      love.graphics.rectangle("line", world:getRect(v))
    end
    for _, ch in ipairs(chars) do
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
    chars[current].isControlled = false
    current = (current%#chars)+1
    chars[current].isControlled = true
  end
end)(1) -- muhehehehe

function love.keypressed(key)
  if key=='tab' then switchPlayer() end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
