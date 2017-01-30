local res = {
  palette = {
    {250,237,217}, --white
    {128, 143, 18}, --light green
    {42,92,11}, -- green
    {4,38,8}, -- dark green
    {234,42,21}, -- red
  },
  font = {
    debug = love.graphics.setNewFont( 14 ),
    talk = love.graphics.setNewFont( 'font/SerreriaSobria.otf', 10)
  },
  music = {
    love.audio.newSource('music/03 - Solxis - Rainforest.mp3', 'stream' )
  },
  sfx = {
    walk = {"106115__j1987__forestwalk.wav", loop=1},
    land_ch = {"235521__ceberation__landing-on-ground.wav"},
    land_b = {"136887__animationisaac__box-of-stuff-falls.wav", vol=.2},
    death = {"76960__michel88__deathh.wav"},
    pickup = {"171644__fins__scale-g6.wav"},
    pickup2 = {"171642__fins__scale-a6.wav"},
    unlock = {"160215__qubodup__unlocking-door-lock.wav"},
    locked = {"151584__d-w__door-handle-jiggle-05.wav", vol=.7},
  }
}

res.music[1]:setLooping( true )
res.music[1]:setVolume(.7)
res.music[1]:play()

for k, v in pairs(res.sfx) do
  print("Loading sfx", k, v[1])
  v.src = love.audio.newSource( 'sfx/'..v[1], 'static' )
  if v.vol then v.src:setVolume(v.vol) end
  if v.loop then v.src:setLooping(true) end
end

return res
