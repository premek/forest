-- 'playing' gamestate, controlling levels
local debug = require "dbg"

love.graphics.setDefaultFilter("nearest")

local r = {}

r.levels = require.treeArray("level")

r.current = 1
r.next = function()
  r.current = (r.current or 0) + 1
end
r.load = function()
  return r.levels[r.current]() -- instantiate the level
end

r.level = r.load()

r.update = function(dt)
  r.level:update(dt)
  if r.level.finished then
    r.next()
    r.level = r.load()
  end
  if r.level.dead then
    r.level = r.load()
  end
end

r.draw = function ()
  r.level:draw()
  debug.draw(r.level)
end

r.keypressed = function (key)
  r.level:keypressed(key)
  if key=='d' then debug.enabled = not debug.enabled end
  if key=='r' then r.level = r.load() end
  if key=='.' then r.next(); r.level = r.load() end
end

return r
