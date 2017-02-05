local love = love -- Baby don´t hurt me
local sti = require "lib.sti"
local bump = require "lib.bump"
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?
local Signal = require 'lib.hump.signal'
local camera = require 'lib.hump.camera'
local Timer = require "lib.hump.timer"
local textboxes = require "textboxes"
local story = require "story"


-- stop dialogs
Signal.register('new_level', Timer.clear)


return require 'lib.hump.class' {
  -- XXX do I need classes? or just level data + level controller?

  gravity = vector(0,.1),
  scene = false,

  -- new() and load() (call from load())
  init = function(self)
    Signal.emit('new_level', self, self.name, self.mapfile)
    print("Creating & loading level", self.mapfile)

    if not love.filesystem.exists(self.mapfile) then
      error("File not found: ".. self.mapfile)
    end

    self.world = bump.newWorld()
    self.map = sti.new(self.mapfile, { "bump" })



    for _,obj in ipairs(self.map.layers.objects.objects) do
      local tile = self.map.tiles[obj.gid]
      local tileI
      if tile ~= nil then -- else it is just a shape object without image
        for _, tileInst in ipairs(self.map.tileInstances[tile.gid]) do
          if tileInst.gid == tile.gid then tileI = tileInst; break end
        end
      end

      obj._tile = tile
      obj._tileInst = tileI
      if tile then obj._currentQuad = tile.quad end -- for animations, see update()
      if obj.gid then obj.y = obj.y - obj.height end
    end

    local objects = self.map.layers.objects.objects
    local objLayer = self.map:convertToCustomLayer("objects")
    self.map.layers.objects.objects = objects

    local level = self

    objLayer.update = function(layer, dt)
      for _, o in pairs(layer.objects) do
        if o._tile and o._tile.animation then
          o._currentQuad = level.map.tiles[tonumber(o._tile.animation[o._tile.frame].tileid) + level.map.tilesets[o._tile.tileset].firstgid].quad
        end
      end
    end

    objLayer.draw = function(layer)
        for _, o in pairs(layer.objects) do
          if o._tile then
            love.graphics.draw(level.map.tilesets[o._tile.tileset].image, o._currentQuad, o.x, o.y)
          end
        end
    end


    self.map:bump_init(self.world) 	--- Adds each collidable tile to the Bump world.

    self.chars = {}
    local controlled
    for k, o in ipairs(self.map.layers.objects.objects) do
      if o.type == "char" then
        local CH = require ("char."..o.name)
        local ch = CH(o.x, o.y, o.width, o.height, o.name)
        ch:load()
        self.map.layers.objects.objects[k] = ch -- FIXME
        table.insert(self.chars, ch)
        if o.properties and o.properties.controlled then controlled = ch end
      end

      if o.type == "collect" or o.type == "move" then
        o.speed = vector(0,0)
      end
    end

    for _, o in ipairs(self.map.layers.objects.objects) do
      self.world:add(o, o.x, o.y, o.width, o.height)
    end

    if controlled then
      self.controlledChar = controlled
    elseif #self.chars > 0 then
      self.controlledChar = self.chars[1]
    end
    self.controlledChar.isControlled = true

    -- camera
    local camX,camY = self:getCameraPos(self.controlledChar)
    self.cam = camera(camX, camY, 2)
    self.cam.smoother = camera.smooth.damped(5) -- TODO do it nicer

    if self.introCutscene then self:cutscene(self.introCutscene) end

    self:storyCutscene(self.name)

  end,

  getCameraPos = function(self, lookAt)
    local a = 64 / (self.cam and self.cam.scale or 2);
    local b = (self.cam and self.cam.scale or 2) / 2
    local camX = math.min(math.max(lookAt.x+16, a*6.5),a*(self.map.width*b-6.5)) -- FIXME!!!
    local camY = math.min(math.max(lookAt.y+16, a*6.5),a*(self.map.height*b-6.5))
    return camX, camY
  end,

  update = function(self, dt)
    Timer.update(dt)

    self.map:update(dt)
    textboxes:update(dt)
    for _,o in ipairs(self.map.layers.objects.objects) do
    if o.speed and self.world:hasItem(o) then -- check if it was not removed in this same iteration by another item

      local original = {
        grounded = o.grounded,
        speed = o.speed:clone(),
      }

      local speedLen = o.speed:len()
      if speedLen < 0.1 and speedLen > 0 then o.speed = vector(0,0) end

      o.speed = o.speed + self.gravity
      -- TODO 0 friction in air, else other objects friction - implement mud, ice, ...
      o.speed.x = o.speed.x * .9

      if o.update then o:update(dt) end

      if o.speed:len() ~= 0 then
        local cols
        o.x, o.y, cols, _ =
          self.world:move(o, o.x + o.speed.x, o.y + o.speed.y,
            function (o1, o2) return self:getCollisionType(o1, o2) end)
        o.grounded = false
        for _, col in ipairs(cols) do
          self:collision(o, col.other, col)
        end
        -- TODO some tollerance
        -- to be able to jump up between 2 tiles
        -- or to fall down into a hole of size of 1 tile
      end
      if o.grounded and not original.grounded then
        Signal.emit('object_landed', o)
        self.cam.shake = original.speed.y * .07 - .2 -- FIXME only for long jumps
      elseif not o.grounded and original.grounded then Signal.emit('object_takeoff', o)
      end

      if o.grounded and o.speed.x ~= 0 and original.speed.x == 0 then Signal.emit("object_slide_start")
      elseif o.grounded and o.speed.x == 0 and original.speed.x ~= 0 then Signal.emit("object_slide_stop")
      end

    end
    end

    self.cam:lockPosition(self:getCameraPos(self.lookAtChar and self.lookAtChar or self.controlledChar))
         --love.graphics:getWidth()/2 - 50, love.graphics:getWidth()/2 + 50,
         --love.graphics:getHeight()/2 - 100, love.graphics:getHeight()/2 + 100)
    self.cam.shake = math.max(0, (self.cam.shake or 0) - dt)

    if self.cam.shake then self.cam:move(math.random(-self.cam.shake*4, self.cam.shake*4),
             math.random(-self.cam.shake*30,self.cam.shake*30)) -- FIXME decreasing amptitude, not random
    end

  end,

  getCollisionType = function(self, moving, other)
    local levelColType = (self.getLevelCollisionType and self:getLevelCollisionType(moving, other))

    if other.name == "door" then return 'slide' end

    if levelColType then return levelColType end
    if other.type == "action"
    or other.type == "collect"
    or other.type == "char" then
      return 'cross'
    else
      return "slide"
    end
    --if     other.isCoin   then return 'cross'
    --elseif other.isWall   then return 'slide'
    --elseif other.isExit   then return 'touch'
    --elseif other.isSpring then return 'bounce'
    --end
    -- else return nil
  end,

  -- resolve collision of the moving object only.
  -- if the other one moves too, it will be called for it too
  collision = function(self, moving, other, collision)
    -- general actions on objects
    if other.layer and other.layer.name == "objects" then
      --print("Object collision", moving.name, moving.type, ",", other.name, other.type)
      if other.type == "collect" then
        if moving.collect and moving:collect(other) then
          self.world:remove(other)
          for k, obj in ipairs(self.map.layers.objects.objects) do --FIXME eew
            if obj.id == other.id then table.remove(self.map.layers.objects.objects, k) end
          end
          Signal.emit("object-collected", moving, other)
          -- FIXME bird takes the item but it does not disappear - is it "collected"?
        end
        if self.collected then self:collected(moving, other) end
      elseif other.type == "move" then
        Signal.emit("object-moved", moving, other)
        other.speed.x = other.speed.x - collision.normal.x * 0.5
        other.speed.y = other.speed.y - collision.normal.y *  0.5 -- dt? moving.speed?
        --moving.speed.x = moving.speed.x * 0.5
        --moving.speed.y = moving.speed.y * 0.5
        if self.moving then self:moving(moving, other) end
      elseif other.type == "action" then
        -- level specific actions
        self:globalActions(moving, other)
        if self.action then self:action(moving, other) end
      end
    end

    if other.type ~= "collect"
      and other.type ~= "action"
      and other.type ~= "char" then
      self:physics(moving, collision)
    end
    -- object specific actions
    if moving.collision then moving:collision(other, collision) end
    if other.collision then other:collision(moving, collision) end
  end,

  globalActions = function(self, moving, other)
    if moving.type=="char" and moving.name=="shaman" and other.name == "finish" then
      self.finished = true
      Signal.emit("level-finished", self)
    end
    if moving.type=="char" and other.name == "lava" then
      print("died")
      Signal.emit("char-died", moving)
      self.dead = true
    end
  end,

  -- resolve physics (speed, grounding) for the object that just moved and colided
  physics = function(self, obj, col)
    if col.normal.y < 0 then
      -- feet touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.y = 0
      obj.grounded = true
    end
    if col.normal.y > 0 then
      -- head touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.y = -.1
       -- this is to allow jumping in a space of size of 1 tile
       -- increase to implement 'hold/stick to ceiling'
       -- FIXME what is a good value in relation to gravity and jump speed
    end
    if col.normal.x ~= 0 then
      -- left or right touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.x = 0
    end
  end,

  switchPlayer = function(self)
    if #self.chars > 1 then
      for k, ch in ipairs(self.chars) do
        if ch.isControlled then
          ch.isControlled = false
          self.chars[(k%#self.chars)+1].isControlled = true
          self.controlledChar = self.chars[(k%#self.chars)+1]
          break
        end
      end
    end
  end,


  cutscene = function(self, scene)
    if self.scene then return end
    Timer.script(function(wait)

      local say = function(who, what)
                  self.lookAtChar = who
                  wait(.5)
                  Signal.emit("char_say", who, what)
                  wait(what:len()*.1+.5)
      end

        self.scene = true
        local cc = self.controlledChar
        cc.isControlled = false
        local orig_scale = self.cam.scale
        Timer.tween(.5, self.cam, {scale = 3}, "in-out-sine")
        wait(.5)
        scene(self, say, wait)

        Timer.tween(1, self.cam, {scale = orig_scale}, "in-out-sine")
        cc.isControlled = true
        self.scene = false

    end)
  end,

  storyCutscene = function(self, knotName)
  if not knotName then return end
   self:cutscene(function(lvl, say, wait)
    story.choosePathString(knotName)
    while story.canContinue do
      local line = story.continue()
      local actor, text = string.match(line, '^(%d+)%s*:%s*(.*)')
      if actor == nil then text = line else actor = tonumber(actor) end
      say(lvl.chars[actor], text) -- TODO use char names in story, not numbers
    end
   end)
  end,

  keypressed = function(self, key)
    if key=='tab' and not self.scene then self:switchPlayer() end
  end,

  draw = function(self)
    self.cam:attach()
    --love.graphics.setColor(255, 255, 255, 255)
    --love.graphics.scale(2)
    --map:setDrawRange(0, 0, windowWidth, windowHeight) --culls unnecessary tiles
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
    textboxes:draw(self.cam)
    self.cam:detach()

  end

}
