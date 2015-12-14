local tidal = require "lib/Tidal/src"
local HC = require "lib/HC"
require "util"
--http://hump.readthedocs.org/en/latest/
-- http://www.headchant.com/2012/01/06/tutorial-creating-a-platformer-with-love-part-1/
local map, hero




function love.load()
  map = tidal.load('map/green.tmx')
  map.batch_draw = true -- Enable spritebatches (default)
  --layer = map.layerOrder[1]  -- Get lowest layer
  --layer.opacity      = 0.5   -- Set layer transparency
  --layer.ox, layer.oy = 5,5   -- Offset layer by these many pixels
  --layer.visible      = true  -- Set layer visibility
  --tile = layer:get(tx,ty)    -- Return tile at tx,ty
  --gid  = 1
  --tile = map.tiles[gid]             -- Get tile
  --print(tile.properties.myproperty) -- Get set property in Tiled


    -- load HardonCollider, set callback to on_collide and size of 100

  hero = HC.rectangle(42,300,20,20)
  tiles = findSolidTiles(map)
end




function findSolidTiles(map)

    local collidable_tiles = {}

    for tileX=0,map.width do
        for tileY=0,map.height do
local layer = map.layerOrder[2]
            local tile = layer:get(tileX,tileY)
            if tile then
                local ctile = HC.rectangle((tileX)*32,(tileY)*32,32,32)
                ctile.type = "tile"
                --HC.addToGroup("tiles", ctile)
                --ollider:setPassive(ctile)
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

function updateHero(dt)
    hero:move(0,dt*50)

end


function love.update(dt)
    map:update(dt) -- For animating tiles

        -- do all the input and movement
    -- check for collisions
    print("---------------")
    for shape, delta in pairs(HC.collisions(hero)) do
        print("Colliding. Separating vector = (%s,%s)",
                                      delta.x, delta.y)
                                      shape:draw("fill")
                                    hero:move(delta.x, delta.y)
                                    end

    handleInput(dt)
    updateHero(dt)


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
