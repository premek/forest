local tidal = require "lib/Tidal/src"
local HC = require "lib/HC"
require "util"
--http://hump.readthedocs.org/en/latest/
local map, hero, objects




function love.load()
  map = tidal.load('map/green.tmx')
  hero = HC.rectangle(42,300,20,20)
  walls = findTiles(map, 2)

end




function findTiles(map, layer)

  local collidable_tiles = {}

  for tileX=0,map.width do
    for tileY=0,map.height do
      local layer = map.layerOrder[layer]
      local tile = layer:get(tileX,tileY)
      if tile then
        local ctile = HC.rectangle(tileX*32,tileY*32,32,32)
        ctile.tile = tile
        table.insert(collidable_tiles, ctile)
      end
    end
  end
  return collidable_tiles
end


function handleInput(dt)

  if love.keyboard.isDown("left") then
    hero:move(-50*dt, 0)
  end
  if love.keyboard.isDown("right") then
    hero:move(50*dt, 0)
  end
  if love.keyboard.isDown("up") then
    hero:move(0, -100*dt)
  end

end



function love.update(dt)
  map:update(dt) -- For animating tiles

  for shape, delta in pairs(HC.collisions(hero)) do
    hero:move(delta.x, delta.y)
  end

  handleInput(dt)
  hero:move(0,dt*50)

end


function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.push()
	--love.graphics.translate(400,300) -- center the map
	love.graphics.scale(2)

	if map then
		map:draw()
	end

  love.graphics.setColor(255,0,0)

  --for k,v in ipairs(tiles) do v:draw("line") end
  hero:draw("fill")

  love.graphics.pop()
end
