local love = love

local tidal = require "lib/Tidal/src"
local HC = require "lib/HC"
local Camera = require "lib.hump.camera"
local vector = require "lib.hump.vector"
require "util"
--http://hump.readthedocs.org/en/latest/

local debug = true


local map, hero, objects, walls, cam
local lg = love.graphics
local lgw, lgh = lg.getWidth(), lg.getHeight()

local gravity = vector(0, 2)
local friction = vector(.9, 1)

local player = {
  pos = vector(42,300),
  velocity = vector(0,0),
  acceleration = vector(10, 100),
  jump = 0,
  jump_max = 1,
  counters = {
    anim = 0
  },

  update = function(self, dt)

        if love.keyboard.isDown('left') then
          self.velocity.x = self.velocity.x - self.acceleration.x * dt
        elseif love.keyboard.isDown('right') then
          self.velocity.x = self.velocity.x + self.acceleration.x * dt
        end
        if self.grounded and self.jump>0 and love.keyboard.isDown('up') then
          self.jump = self.jump - dt
          self.grounded = false
          self.velocity.y = self.velocity.y - self.acceleration.y * (dt / self.jump_max)
        end



        -- grvity
      self.velocity = self.velocity + gravity * dt
      self.velocity.x = self.velocity.x * friction.x
      self.velocity.y = self.velocity.y * friction.y
      if self.velocity:len()<0.01 then self.velocity = vector(0,0) end

      self.pos = self.pos + self.velocity



          hero:moveTo(self.pos.x, self.pos.y)


            for shape, delta in pairs(HC.collisions(hero)) do
              self.pos = self.pos + delta
              if math.abs(delta.x)>0 then self.velocity.x=0
              elseif math.abs(delta.y)>0 then self.velocity.y=0 end

              if delta.y<0.2 then
                print(delta.y)
                self.grounded = true
                self.jump = self.jump_max
              end

              hero:moveTo(self.pos.x, self.pos.y)
            end

 self.counters.anim = self.counters.anim + dt
    local qn = 0
            if not self.grounded then qn = math.floor(self.counters.anim*10) % #quads end
            print (qn)
            self.quad = quads[qn+1]

  end
}




function love.load()
  cam = Camera()
  --cam:lockY(player.pos.y, Camera.smooth.damped(1))

  map = tidal.load('map/green.tmx')
  hero = HC.rectangle(player.pos.x, player.pos.y, 30,30)
  walls = findTiles(map, 2)

  lg.setDefaultFilter("nearest", "nearest")

     image = love.graphics.newImage("img/flappyflap.png")
   quads = {
     love.graphics.newQuad(32*0, 0, 32, 32, image:getDimensions()),
     love.graphics.newQuad(32*1, 0, 32, 32, image:getDimensions()),
     love.graphics.newQuad(32*2, 0, 32, 32, image:getDimensions()),
     love.graphics.newQuad(32*3, 0, 32, 32, image:getDimensions()),
   }

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

function love.keypressed(key)
  if key=='tab' then print("PL") end
  if key=='d' then debug = not debug end
  if key=='escape' then love.event.quit() end
end

function love.update(dt)
  map:update(dt) -- For animating tiles
  player:update(dt)

end


function love.draw()
  cam:attach()

  love.graphics.setColor(255,255,255)
  love.graphics.push()
	--love.graphics.translate(400,300) -- center the map
	love.graphics.scale(2)

	if map then
		map:draw()
	end
  love.graphics.setColor(255,255,255)
  lg.draw(image, player.quad, player.pos.x-16, player.pos.y-16)


  if debug then
    love.graphics.setColor(255,0,0)
    for k,v in ipairs(walls) do v:draw("line") end
    hero:draw("fill")

      love.graphics.setColor(0,255,0)
      lg.line(player.pos.x, player.pos.y, player.pos.x+player.velocity.x*50, player.pos.y+player.velocity.y*50)
  end


  love.graphics.pop()

  cam:detach()

end
