local Signal = require 'lib.hump.signal'
local sfx = require "resources".sfx

Signal.register('object_landed', function(obj)
  if obj.land_played ~= nil and not obj.land_played then
    if obj.type == "char" then
      sfx.land_ch.src:play()
    elseif obj.name == "box" then
      sfx.land_b.src:play()
    end
  end
end)

Signal.register('object_takeoff', function(obj) obj.land_played = false end)

Signal.register('object_takeoff', function(obj) sfx.walk.src:stop() end)
Signal.register('object_slide_start', function(obj) sfx.walk.src:play() end)
Signal.register('object_slide_stop', function(obj) sfx.walk.src:stop() end)

Signal.register('char-died', function(ch) if ch.name=="shaman" then sfx.death.src:play() end end)
Signal.register('object-collected', function(who, what) sfx.pickup2.src:play() end)
Signal.register('level-finished', function(level) sfx.pickup.src:play() end)

Signal.register('door-open', function(door, char) sfx.unlock.src:play() end)
Signal.register('door-locked', function(door, char) sfx.locked.src:play() end)
