local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local camera = require 'lib.hump.camera'
local Character = require "character"
require "util"

local debug = true

local map, world, player, cam

local zoom, shake = 2, 0

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  cam = camera(0,0, zoom)

  love.graphics.setDefaultFilter("nearest")
  map = sti.new("map/green.lua", { "bump" })
  world = bump.newWorld()
  map:bump_init(world) 	--- Adds each collidable tile to the Bump world.
  player = Character(world, "img/shaman.png", 64, 64)

  map:addCustomLayer("Sprite Layer", 3)
  -- Add data to Custom Layer
  local spriteLayer = map.layers["Sprite Layer"]
  spriteLayer.sprites = {player}

  -- Update callback for Custom Layer
  function spriteLayer:update(dt)
    for _, sprite in pairs(self.sprites) do
      --sprite.r = sprite.r + math.rad(90 * dt)
    end
  end

  -- Draw callback for Custom Layer
  function spriteLayer:draw()
    for _, sprite in pairs(self.sprites) do
      --local x = math.floor(sprite.pos.x)
      --local y = math.floor(sprite.y)
      --love.graphics.draw(sprite.image, x, y)
    end
  end
end

function love.update(dt)
  map:update(dt)
  player:update(dt)
  world.shake = math.max(0, (world.shake or 0) - dt)
  if world.shake > 0 then print(world.shake) end
end

function love.draw()
  cam:lookAt(love.graphics.getWidth()*.5/zoom,love.graphics.getHeight()*.5/zoom)
  cam:move(math.random(-world.shake*5,world.shake*5),
           math.random(-world.shake*5,world.shake*5))

  cam:attach()
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.scale(2)
  --map:setDrawRange(0, 0, windowWidth, windowHeight) --culls unnecessary tiles
  map:draw()
  player:draw()

  if debug then
    love.graphics.setColor(255, 0, 0, 255)
    for _, v in ipairs(world:getItems()) do
      love.graphics.rectangle("line", world:getRect(v))
    end
    love.graphics.setColor(0,255,0)
    love.graphics.line(player.pos.x, player.pos.y, player.pos.x+player.speed.x*10, player.pos.y+player.speed.y*10)
  end

  cam:detach()

end

function love.keypressed(key)
  if key=='tab' then print("PL") end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
