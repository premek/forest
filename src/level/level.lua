local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"

return require 'lib.hump.class' {

  init = function(self)
    self.world = bump.newWorld()

    local file = "map/"..self.mapfile..".lua"
    if not love.filesystem.exists(file) then error("File not found: ".. file) end
    self.map = sti.new(file, { "bump" })
    self.map:bump_init(self.world) 	--- Adds each collidable tile to the Bump world.

    -- FIXME I dont like this. do character need to have map and world?
    for _,v in ipairs(self.chars) do
      v:world(self.world, self.map)
    end
    self.chars[1].isControlled = true
  end,

  update = function(self, dt)
    self.map:update(dt)
    for _,char in ipairs(self.chars) do char:update(dt) end
  end,

  draw = function(self)
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
  end

}
