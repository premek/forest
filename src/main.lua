local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local Character = require "character"
require "util"

local debug = true

local map, world, player


function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
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
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.scale(2)
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

end

function love.keypressed(key)
  if key=='tab' then print("PL") end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end
