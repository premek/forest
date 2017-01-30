local love = love
require "lib.util"
require "lib.require"

require "sfx" -- register signals, does not return
local game = require "game"

function love.update(dt)
  game.update(dt)
end

function love.draw()
  game.draw()
end

function love.keypressed(key)
  game.keypressed(key)
  if key=='escape' then love.event.quit() end
end
