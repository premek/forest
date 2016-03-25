local Signal = require 'lib.hump.signal'

local sfx = {
  walk = {"106115__j1987__forestwalk.wav", loop=1},
  land_ch = {"235521__ceberation__landing-on-ground.wav"},
  land_b = {"136887__animationisaac__box-of-stuff-falls.wav", vol=.2},
  death = {"76960__michel88__deathh.wav"},
  pickup = {"171644__fins__scale-g6.wav"},
  pickup2 = {"171642__fins__scale-a6.wav"},
  unlock = {"160215__qubodup__unlocking-door-lock.wav"},
  locked = {"151584__d-w__door-handle-jiggle-05.wav", vol=.7},
}

Signal.register('level-complete', function()  end)

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


--------

for k, v in pairs(sfx) do
  print("Loading sfx", k, v[1])
  v.src = love.audio.newSource( 'sfx/'..v[1], 'static' )
  if v.vol then v.src:setVolume(v.vol) end
  if v.loop then v.src:setLooping(true) end
end

return nil
