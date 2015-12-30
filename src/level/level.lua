local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local maputils = require "maputils"

return require 'lib.hump.class' {
  -- XXX do I need classes? or just level data + level controller?

  -- new() and load() (call from load())
  init = function(self)
    print("Creating & loading level", self.mapfile)

    if not love.filesystem.exists(self.mapfile) then
      error("File not found: ".. self.mapfile)
    end

    self.world = bump.newWorld()

    self.map = sti.new(self.mapfile, { "bump" })
    self.map:bump_init(self.world) 	--- Adds each collidable tile to the Bump world.

    self:load()

    for _,ch in ipairs(self.chars) do
      ch:load()
      self.world:add(ch, ch.pos.x, ch.pos.y, ch.size.x, ch.size.y)
    end
  end,

  load = function(_) end, -- to be implemented in subclasses or left empty

  update = function(self, dt)
    self.map:update(dt)

    for _,char in ipairs(self.chars) do
      char:update(dt)

      local newPos = char.pos + char.speed

      if char.speed:len() ~= 0 then

        local actualX, actualY, cols, _ = self.world:move(char, newPos.x, newPos.y,
         function (char, other) return self:getCollisionType(char, other) end)

        local original = {
          grounded = char.grounded,
          speed = char.speed:clone(),
        }

        char.grounded = false -- no collisions, no jumping

        for _, col in ipairs(cols) do
          self:collision(char, col.other, col)
        end

        -- TODO some tollerance
        -- to be able to jump up between 2 tiles
        -- or to fall down into a hole of size of 1 tile

        char.pos.x = actualX
        char.pos.y = actualY

        if char.grounded and not original.grounded then
          -- FIXME store somewhere else than in "world"
          self.world.shake = original.speed.y * .07 - .2 -- FIXME only for long jumps
        end
      end
    end
  end,


  getCollisionType = function(self, char, other)
    local levelColType = self.getLevelCollisionType and self:getLevelCollisionType(char, other)
    if levelColType then return levelColType end

    if other.type == "action"
    or other.type == "collect" then
      return 'cross'
    else return "slide"
    end
    --if     other.isCoin   then return 'cross'
    --elseif other.isWall   then return 'slide'
    --elseif other.isExit   then return 'touch'
    --elseif other.isSpring then return 'bounce'
    --end
    -- else return nil
  end,

  collision = function(self, char, object, collision)
    if object.layer and object.layer.name == "objects" then
      print("Object collision", char.type, object.name, object.type)
      if object.type == "collect" and char:collect(object.name) then
        self.world:remove(object)
        maputils.removeObjectByItem(self.map, object)
      end
      self:action(char, object)
    else
    if char.collision then char:collision(object, collision) end
    if object.collision then object:collision(char, collision) end
  end
  end,

  draw = function(self)
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
  end

}
