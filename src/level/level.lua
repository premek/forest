local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local maputils = require "maputils"

return require 'lib.hump.class' { -- XXX do I need classes? or just level data + level controller?

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

        local actualX, actualY, cols, _ = self.world:move(char, newPos.x, newPos.y, char.getCollisionType)

        local original = {
          grounded = char.grounded,
          speed = char.speed:clone(),
        }

        char.grounded = false -- no collisions, no jumping

        for _, col in ipairs(cols) do
          local actionCalled = self:callAction(char, col.other)

          if not actionCalled then
            local collected = char:collect(col.other)

            if collected then
              self.world:remove(col.other)
              maputils.removeObjectByItem(self.map, col.other)
            else char:collideWith(col.other, col) end

          end
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

  callAction = function(self, char, item)
    if item.layer and item.layer.name == "objects"
      and item.type == "action" then
        print("Action", char.type, item.name)
        self:action(char, item)
      return true
    end
  end,

  draw = function(self)
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
  end

}
